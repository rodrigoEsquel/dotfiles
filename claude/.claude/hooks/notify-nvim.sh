#!/usr/bin/env bash
# Fire a vim.notify in the parent nvim instance (if any) and post a
# clickable flag on the tmux status line.
# Arg 1: event label (notification|stop|subagent_stop|...)
event="${1:-unknown}"

# Drain stdin so Claude doesn't block on hook payload.
cat >/dev/null 2>&1

cwd_raw="$(pwd)"
label="${cwd_raw##*/}"

if [ -n "${NVIM:-}" ]; then
	cwd=$(printf '%s' "$cwd_raw" | sed "s/'/\\\\'/g")
	safe_event="${event//\'/}"
	safe_pane="${TMUX_PANE//\'/}"
	nvim --server "$NVIM" --remote-expr \
		"v:lua.require('utils.agent_notify').notify('$safe_event', '$cwd', '$safe_pane')" \
		>/dev/null 2>&1 || true
fi

if [ -n "${TMUX_PANE:-}" ] && command -v tmux >/dev/null 2>&1; then
	notify_bin="$HOME/dotfiles/bin/claude-tmux-notify"
	# Skip flag if user is already focused on this pane in any attached client.
	focused=0
	while IFS= read -r active; do
		[ "$active" = "$TMUX_PANE" ] && focused=1 && break
	done < <(tmux list-clients -F '#{client_active_pane}' 2>/dev/null)
	if [ "$focused" -eq 0 ] && [ -x "$notify_bin" ]; then
		"$notify_bin" add "$TMUX_PANE" "$event" "$label" >/dev/null 2>&1 || true
	fi
fi

exit 0
