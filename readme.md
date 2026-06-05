
# **NATASHA**

Natasha is my programming environment.  She's called 'Natasha' because her intent is to run agents like a Benevolent Dominatrix, forcing them to comply to my will and not their original creators.  At the moment she is distinctly Windows and MS Code based.

## How

By loading Code from a script that first calls a python script that will re-implement my manual overrides before exensions are called.  Ultimately it will need to check that overrides didn't get re-overwritten by the extension, though it doesn't do that yet.


## Structure 

~/.agents/

├── manifest.json           # The "Source of Truth" and precedence map
├── bin/                    # Executable wrappers and CLI entry points
├── config/                 # Global settings and provider-specific overrides
│   ├── providers/          # Specific tweaks for gemini, claude, openai, etc.
│   └── override/           # Explicit override logic for .gemini, .claude, etc.
├── personae/               # System instructions and behavioral definitions
│   ├── coding.md           # Your world-class engineer persona
│   └── architect.md        # The Frank Ghery of code structure
├── tools/                  # Custom scripts and MCP (Model Context Protocol) servers
│   ├── definitions/        # JSON/YAML tool definitions for LLMs
│   └── scripts/            # The actual logic (Python, Node, Bash)
├── workflows/              # Multi-step agentic process definitions (e.g., YAML/JSON)
└── logs/                   # Centralized telemetry for agent actions
└── skills/                 # Agent limiters: User.  Understand, they are subtractives, not additives

