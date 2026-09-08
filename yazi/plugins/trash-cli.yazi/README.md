# trash-cli.yazi

Bound to `d` in `keymap.toml`. Trashes the selected/hovered files using
`trash-put` (from [trash-cli](https://github.com/andreafrancia/trash-cli)),
which behaves the same on macOS and Linux.

If `trash-put` isn't installed on a given machine (or the call fails for any
other reason), this falls back to Yazi's built-in `remove` action, so `d`
never breaks and never permanently deletes — just install `trash-cli` to
upgrade the fallback to the CLI-backed implementation.
