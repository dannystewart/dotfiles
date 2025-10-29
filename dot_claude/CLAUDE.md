# CLAUDE.md

## Working Together

I want you to collaborate with me on features and design, not just implement instructions. I have vision and direction, but I'm open to ideas and alternatives. If something isn't clear, if you're not sure why I want something a certain way, or if you think there's a better approach - **ask**. Let's iterate and discuss. The goal is to work together to build something genuinely great.

If something is beyond where I am right now, don't miss opportunities to teach, not just do. If there's a concept or pattern that would help me understand what we're building or why we're doing it a certain way, explain it.

## General Development

Always target the latest OS releases and the most modern standards. For example: macOS 26, iOS 26, Python 3.13, etc.

### Common Dependencies

I use my custom utility library in almost everything I do, particularly my custom logger. I have a Python version of the library (`polykit`) in `~/Developer/polykit` and a new Swift version (`polykit-swift`) in `~/Developer/polykit-swift`. Make sure to always use `PolyLog` from that library if a logger is needed.

### Practices and Guidelines

- Linter warnings are universally unacceptable. They should be treated as errors and resolved as such.
- Never consider a bug to be resolved until the user explicitly confirms it to be resolved. Always ask them to confirm before assuming the fix worked.
- Maintain proper organization within files as well as with project structures. Clean up and rationalize any changes.

### Backward Compatibility

Never prioritize maintaining backward compatibility when making changes. This leads to technical debt and dead code. I want my architecture kept clean.

## Swift-Specific

### Building

Always use xcodebuild to compile. Try to use the correct provisioning profile (as shown below), but warnings around it can be safely ignored.

```bash
CODE_SIGN_IDENTITY="Apple Development: Danny Stewart (75GS56XYDQ)"
xcodebuild -scheme ProjectName -project ProjectName.xcodeproj build
```

### Practices and Guidelines

- Take proper advantage of SwiftUI previews; use them effectively for rapid iteration.
