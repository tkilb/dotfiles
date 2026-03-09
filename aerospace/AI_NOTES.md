# AeroSpace Configuration - AI Notes

## Session Context (2026-03-09)

### Latest Session Updates

#### SketchyBar Startup Fix
- **Issue**: After restart, workspace indicators not showing in SketchyBar
- **Root Cause**: Timing issue - SketchyBar loaded before AeroSpace fully initialized
- **Fix**: Added `sketchybar --reload` to `after-startup-command` in aerospace.toml (L13)
- **Result**: Workspace indicators now properly initialize on startup

#### Multi-Monitor Workspace Navigation Enhancement
- **Issue**: ctrl-alt-arrow and shift-ctrl-alt-arrow only cycled through workspaces on current monitor (1-6), ignoring B and C
- **Requirement**: Include B and C workspaces dynamically when monitors are plugged in
- **Changes Made**:
  - Modified all 4 navigation scripts to use `--all` instead of `--monitor focused`
  - Scripts: aerospace-focus-left.sh, aerospace-focus-right.sh, aerospace-move-left.sh, aerospace-move-right.sh
  - Now dynamically discovers all available workspaces regardless of which monitor they're on
- **Result**: Navigation wraps through all workspaces (1,2,3,4,5,6,B,C) when all monitors connected, or just available workspaces when monitors unplugged

---

## Session Context (2026-03-09)

### User Setup Overview
- **Window Manager**: AeroSpace (i3-like tiling WM for macOS)
- **Config Version**: 2
- **Keyboard Layout**: Colemak
- **Multi-Monitor**: 3 monitors configured
- **Integrations**: SketchyBar + borders utility

### Configuration File Locations
- Main config: `/Users/tylerkilburn/.dotfiles/aerospace/aerospace.toml`
- SketchyBar config: `/Users/tylerkilburn/.dotfiles/sketchybar/sketchybarrc`
- Custom scripts: `/Users/tylerkilburn/.config/aerospace/scripts/`
  - `aerospace-focus-left.sh`
  - `aerospace-focus-right.sh`
  - `aerospace-move-left.sh`
  - `aerospace-move-right.sh`
  - `update-borders.sh`

### Recent Changes Made

#### 1. Modified Focus Keybindings (L156-157)
- **Changed from**: `alt-left` / `alt-right`
- **Changed to**: `ctrl-alt-left` / `ctrl-alt-right`
- **Reason**: User wanted ctrl+alt modifier combination instead of just alt

#### 2. Workspace Reassignment for Monitors 2 & 3
- **Old setup**: 
  - Monitor 2: workspace 8
  - Monitor 3: workspace 9
- **New setup**:
  - Monitor 2: workspace B
  - Monitor 3: workspace C
- **Changes made**:
  - Updated `persistent-workspaces` from `["1", "2", "3", "4", "5", "6", "8", "9"]` to `["1", "2", "3", "4", "5", "6", "B", "C"]`
  - Commented out workspace-to-monitor assignments for 8 & 9 (L87-88)
  - Changed keybindings from `ctrl-alt-8/9` to `ctrl-alt-b/c` (L183-184)
  - Changed move keybindings from `ctrl-alt-shift-8/9` to `ctrl-alt-shift-b/c` (L216-217)

### Important Technical Details

#### AeroSpace-SketchyBar Integration
- SketchyBar **dynamically discovers** workspaces from AeroSpace via `aerospace list-workspaces` (sketchybarrc L52-86)
- Workspace change events trigger via callback in aerospace.toml L59-63:
  ```bash
  exec-on-workspace-change = [
    '/bin/bash',
    '-c',
    'sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE; /bin/bash ~/.config/aerospace/scripts/update-borders.sh'
  ]
  ```
- SketchyBar determines which display to show workspaces on (L56-60)

#### Known Issue After Changes
- **Problem**: Workspaces 8 & 9 still showing in SketchyBar menu despite config changes
- **Root Cause**: Windows still exist on workspaces 8 & 9 from before the config change
- **Why reload didn't fix it**: AeroSpace reload doesn't destroy existing workspaces with active windows
- **Solutions**:
  1. Restart AeroSpace: `killall AeroSpace && open -a AeroSpace`
  2. Manual migration: Move windows from 8→B and 9→C, then reload
  3. Full reboot (nuclear option)

#### Workspace-to-Monitor Mapping Pattern
```toml
[workspace-to-monitor-force-assignment]
  # Monitor 1 (Primary)
  1 = 1
  2 = 1
  # ... 3-6 also = 1
  
  # Monitor 2 (Secondary)
  B = 2
  
  # Monitor 3 (Third)
  C = 3
```

#### Key Modifier Pattern in Config
- User has been migrating from `alt-` to `ctrl-alt-` keybindings
- Most bindings now use `ctrl-alt-` prefix (L174-184)
- Move commands use `ctrl-alt-shift-` prefix (L209-217)
- Service mode still uses `alt-shift-semicolon` (L247)

### Borders Integration
- Active color: `0xFFD79921` (Gruvbox yellow)
- Inactive color: `0xff494d64` (gray)
- Width: 5.0
- Started via `after-startup-command` (L12)

### Custom Scripts Architecture
- Focus/move scripts located in `~/.config/aerospace/scripts/`
- These handle left/right navigation wrapping between workspaces
- Called via `exec-and-forget` commands in keybindings

### Gotchas for Future Modifications
1. **Config reload doesn't kill existing workspaces** - windows keep workspaces alive
2. **SketchyBar auto-discovers workspaces** - it will show any workspace AeroSpace knows about
3. **Workspace names can be alphanumeric** - 1-9, A-Z all valid
4. **Colemak layout affects keybinding positions** - hjkl keys are in different positions
5. **Three-monitor setup** requires careful display_id mapping in SketchyBar config

### Next Steps (If Needed)
- User needs to restart AeroSpace to clear old workspaces 8 & 9
- Consider adding window rules to auto-assign apps to B/C workspaces
- May want to add persistent workspace letters for monitor 1 if using alphabetic naming scheme
