function xcscaffold --description "Scaffold an Xcode project with git-based build numbering via xcconfig + shared scheme"
    set --local xcodeprojs *.xcodeproj
    if test (count $xcodeprojs) -eq 0
        error "No .xcodeproj found in the current directory."
        return 1
    end
    if test (count $xcodeprojs) -gt 1
        error "Multiple .xcodeproj found: $xcodeprojs"
        return 1
    end

    set --local xcodeproj $xcodeprojs[1]
    set --local project_name (basename $xcodeproj .xcodeproj)

    info "Scaffolding $project_name..."

    # Placeholder so Xcode can resolve the base config on first open, before
    # the scheme PreAction regenerates the file on every build.
    set --local config_file Config/BuildNumber.xcconfig
    if not test -f $config_file
        mkdir -p Config
        printf '%s\n' \
            "// Auto-generated. Do not edit by hand." \
            "" \
            "CURRENT_PROJECT_VERSION = 1" \
            "BUILD_IS_DIRTY = false" \
            "BUILD_WORKING_HASH = 000" >$config_file
        success "Created $config_file"
    end

    set --local ruby_script '
require "xcodeproj"
require "fileutils"

project_path = ARGV[0]
project_name = File.basename(project_path, ".xcodeproj")
project = Xcodeproj::Project.open(project_path)

app_targets = project.targets.select { |t| t.product_type == "com.apple.product-type.application" }
if app_targets.empty?
  STDERR.puts "ERROR: No application target found in project."
  exit 1
end
main_target = app_targets.find { |t| t.name == project_name } || app_targets.first
if app_targets.size > 1
  STDERR.puts "WARN: Multiple application targets present; using #{main_target.name}."
end

actions = []

ref = project.main_group.files.find { |f| f.path == "Config/BuildNumber.xcconfig" }
if ref.nil?
  ref = project.main_group.new_file("Config/BuildNumber.xcconfig")
  ref.name = "BuildNumber.xcconfig"
  ref.last_known_file_type = "text.xcconfig"
  actions << "added BuildNumber.xcconfig file reference"
end

project.build_configurations.each do |config|
  next if config.base_configuration_reference == ref
  config.base_configuration_reference = ref
  actions << "set baseConfigurationReference on project (#{config.name})"
end
main_target.build_configurations.each do |config|
  next if config.base_configuration_reference == ref
  config.base_configuration_reference = ref
  actions << "set baseConfigurationReference on #{main_target.name} (#{config.name})"
end

main_target.build_configurations.each do |config|
  next if config.build_settings["CURRENT_PROJECT_VERSION"] == "$(CURRENT_PROJECT_VERSION)"
  config.build_settings["CURRENT_PROJECT_VERSION"] = "$(CURRENT_PROJECT_VERSION)"
  actions << "set CURRENT_PROJECT_VERSION on #{main_target.name} (#{config.name})"
end

project.save

shell_script = %q@
#!/bin/sh
set -e

unset SWIFT_DEBUG_INFORMATION_FORMAT
unset SWIFT_DEBUG_INFORMATION_VERSION

# Manual offset in case commit count decreases
OFFSET=0

# Figure out paths
PROJECT_NAME=$(basename "$PROJECT_FILE_PATH" .xcodeproj)
CONFIG_DIR="${PROJECT_DIR}/Config"
BUILD_CONFIG="${CONFIG_DIR}/BuildNumber.xcconfig"

cd "$PROJECT_DIR"
mkdir -p "$CONFIG_DIR"

# Generate build number from commit count + offset
COMMIT_COUNT=$(git -C "$PROJECT_DIR" rev-list --count HEAD 2>/dev/null || echo 1)
BUILD_NUMBER=$((COMMIT_COUNT + OFFSET))

# Determine dirty/clean status and working tree hash
IS_DIRTY=false
if ! git -C "$PROJECT_DIR" diff --quiet || ! git -C "$PROJECT_DIR" diff --cached --quiet; then
  IS_DIRTY=true
fi

# Get working tree hash
STATUS=$(git status --porcelain=v1 --untracked-files=all)
DIFF=$(git diff HEAD)
BUILD_WORKING_HASH=$(printf "%s\n%s" "$STATUS" "$DIFF" | shasum | cut -c1-3)

# Write values back to BuildNumber.xcconfig
cat > "$BUILD_CONFIG" <<EOF
// Auto-generated. Do not edit by hand.

CURRENT_PROJECT_VERSION = $BUILD_NUMBER
BUILD_IS_DIRTY = $IS_DIRTY
BUILD_WORKING_HASH = $BUILD_WORKING_HASH
EOF

echo "Updated $BUILD_CONFIG to build $BUILD_NUMBER (dirty: $IS_DIRTY)"
@.strip + "\n"

def xml_attr_escape(s)
  s.gsub("&", "&amp;").gsub("<", "&lt;").gsub(">", "&gt;").gsub("\"", "&quot;").gsub("\n", "&#10;")
end

target_uuid = main_target.uuid
buildable_name = "#{project_name}.app"
container_ref = "container:#{project_name}.xcodeproj"
escaped_script = xml_attr_escape(shell_script)

scheme_xml = <<~XML
  <?xml version="1.0" encoding="UTF-8"?>
  <Scheme
     LastUpgradeVersion = "2700"
     version = "1.7">
     <BuildAction
        parallelizeBuildables = "YES"
        buildImplicitDependencies = "YES"
        buildArchitectures = "Automatic">
        <PreActions>
           <ExecutionAction
              ActionType = "Xcode.IDEStandardExecutionActionsCore.ExecutionActionType.ShellScriptAction">
              <ActionContent
                 title = "Run Script"
                 scriptText = "#{escaped_script}">
                 <EnvironmentBuildable>
                    <BuildableReference
                       BuildableIdentifier = "primary"
                       BlueprintIdentifier = "#{target_uuid}"
                       BuildableName = "#{buildable_name}"
                       ReferencedContainer = "#{container_ref}">
                    </BuildableReference>
                 </EnvironmentBuildable>
              </ActionContent>
           </ExecutionAction>
        </PreActions>
        <BuildActionEntries>
           <BuildActionEntry
              buildForTesting = "YES"
              buildForRunning = "YES"
              buildForProfiling = "YES"
              buildForArchiving = "YES"
              buildForAnalyzing = "YES">
              <BuildableReference
                 BuildableIdentifier = "primary"
                 BlueprintIdentifier = "#{target_uuid}"
                 BuildableName = "#{buildable_name}"
                 ReferencedContainer = "#{container_ref}">
              </BuildableReference>
           </BuildActionEntry>
        </BuildActionEntries>
     </BuildAction>
     <TestAction
        buildConfiguration = "Debug"
        selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB"
        selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB"
        shouldUseLaunchSchemeArgsEnv = "YES"
        shouldAutocreateTestPlan = "YES">
     </TestAction>
     <LaunchAction
        buildConfiguration = "Debug"
        selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB"
        selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB"
        launchStyle = "0"
        useCustomWorkingDirectory = "NO"
        ignoresPersistentStateOnLaunch = "NO"
        debugDocumentVersioning = "YES"
        debugServiceExtension = "internal"
        allowLocationSimulation = "YES"
        queueDebuggingEnabled = "No">
        <BuildableProductRunnable
           runnableDebuggingMode = "0">
           <BuildableReference
              BuildableIdentifier = "primary"
              BlueprintIdentifier = "#{target_uuid}"
              BuildableName = "#{buildable_name}"
              ReferencedContainer = "#{container_ref}">
           </BuildableReference>
        </BuildableProductRunnable>
     </LaunchAction>
     <ProfileAction
        buildConfiguration = "Release"
        shouldUseLaunchSchemeArgsEnv = "YES"
        savedToolIdentifier = ""
        useCustomWorkingDirectory = "NO"
        debugDocumentVersioning = "YES">
        <BuildableProductRunnable
           runnableDebuggingMode = "0">
           <BuildableReference
              BuildableIdentifier = "primary"
              BlueprintIdentifier = "#{target_uuid}"
              BuildableName = "#{buildable_name}"
              ReferencedContainer = "#{container_ref}">
           </BuildableReference>
        </BuildableProductRunnable>
     </ProfileAction>
     <AnalyzeAction
        buildConfiguration = "Debug">
     </AnalyzeAction>
     <ArchiveAction
        buildConfiguration = "Release"
        revealArchiveInOrganizer = "YES">
     </ArchiveAction>
  </Scheme>
XML

scheme_dir = File.join(project_path, "xcshareddata", "xcschemes")
scheme_path = File.join(scheme_dir, "#{project_name}.xcscheme")

if File.exist?(scheme_path)
  unless File.read(scheme_path).include?("BuildNumber.xcconfig")
    STDERR.puts "WARN: Scheme exists at #{scheme_path} without our PreAction; left alone. Inspect manually."
  end
else
  FileUtils.mkdir_p(scheme_dir)
  File.write(scheme_path, scheme_xml)
  actions << "wrote shared scheme at #{scheme_path}"
end

if actions.empty?
  puts "  (project already fully scaffolded; no changes)"
else
  actions.each { |a| puts "  - #{a}" }
end
'

    echo $ruby_script | ruby - $xcodeproj
    if test $status -ne 0
        error "Failed to scaffold Xcode project."
        return 1
    end

    success "Done."
end
