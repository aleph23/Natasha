#!/bin/bash

# 1. Kill everything and wipe the cache
echo "--- Nuking stale Jules sessions and clearing cache... ---"
jules session kill --all --clear-cache

# 2. Start a fresh diagnostic task to force a new clone
# This pulls the 10+ commits and reads your new AGENTS.md
echo "--- Initializing fresh VM state from GitHub... ---"
jules task run "Confirming repository territory. Run 'git log -1' and 'ls -R' to ensure AGENTS.md is loaded." --no-commit

echo "--- Reset Complete. The map and the territory now approach alignment."