# Provisioners, null_resource, templatefile

## Three Tools
1. **Provisioners** — file, remote-exec, local-exec
2. **null_resource** — trigger-based execution
3. **templatefile()** — dynamic file generation

## When to Use What
- **user_data + templatefile** — first-boot scripts (preferred)
- **local-exec** — writing output to files, notifications
- **remote-exec** — post-creation commands (last resort)
- **null_resource** — external actions triggered by changes

## Anti-Patterns
- Using remote-exec when user_data works
- Relying on provisioners for configuration management
- Forgetting that provisioners only run at create/destroy time
