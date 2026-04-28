# dotfiles

### Sync with stow:

```bash
stow -t ~/.config -d ~/dotfiles --ignore='^claude$' .
stow -t ~ -d ~/dotfiles claude
```

First command links app configs into `~/.config`. Second links `~/.claude/hooks` (Claude Code hooks only) into `$HOME`.
