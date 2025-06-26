function Set-PIM --description 'Enable or disable PIM'
    # Only execute if called from an interactive fish shell
    if not status is-interactive
        return 0
    end
    
    # Check if we're being called from PowerShell integration
    if test -n "$TERM_PROGRAM" -a "$TERM_PROGRAM" = "vscode"
        # Additional safety check - ensure we have arguments or user intent
        if test (count $argv) -eq 0
            echo "Set-PIM: Use 'Set-PIM -Enable' or 'Set-PIM -Disable' with optional parameters"
            return 0
        end
    end
    
    pwsh "/Users/danny/Developer/iri/iri-powershell/Azure/Set-PIM.ps1" $argv
end
