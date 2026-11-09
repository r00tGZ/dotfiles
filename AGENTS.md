# Project rules

- Use Git for inspection only unless the owner explicitly requests a Git write. Preserve staged, unstaged, and untracked work.
- Create directories only when explicitly requested. Keep Markdown notes in `resources/` and standalone helpers and preseeds in `tools/`. Keep both independent of installation, startup, and completion.
- Preserve personal settings. Keep the bootstrap and controller POSIX sh, the environment compatible with Bash and Zsh, and the README and completion in sync with public commands. Discover software tags from `install/software/*.lst` at runtime.
- Test with temporary homes and mocked privileged commands. Never run package installs, cleanup, VPN connections, or system configuration helpers on the host as tests. Treat reference notes as content.
