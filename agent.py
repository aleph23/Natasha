import json
import os
from pathlib import Path

def load_agent_config():
    base_path = Path.home() / ".agents"
    manifest_path = base_path / "manifest.json"
    
    with open(manifest_path, 'r') as f:
        manifest = json.load(f)
    
    # Logic to prioritize ~/.agents over local .gemini
    # This would be injected into your agent's system prompt or environment
    precedence = manifest.get('precedence', 'normal')
    print(f"Agentic context loaded with {precedence} precedence.")
    
    # Universal override logic
    universal_config = manifest.get('config', {}).get('universal_overrides')
    if universal_config and (base_path / universal_config).exists():
        with open(base_path / universal_config, 'r') as f:
            universal_rules = json.load(f)
        print(f"Applying universal rules from {universal_config}...")
        manifest['active_rules'] = universal_rules

    return manifest

# Example usage in a CLI tool
config = load_agent_config()
print(f"Config loaded; Worm may now begin programming. debug: {config}")
