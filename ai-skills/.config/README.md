# AI Skills Setup

The `ai-skills` package deploys shared skills to `~/.config/skills/`.

After stowing, manually create symlinks for each AI coding tool:
```bash
ln -s ~/.config/skills ~/.claude/skills
ln -s ~/.config/skills ~/.opencode/skills
```

These symlinks are local only and not managed by stow.
