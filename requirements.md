# Requirements for QMK Update

This is an existing QMK project that is working for the user, but they would like a key updated.

The existing codebase is found at ~/.dotfiles/qmk. Read it for context. Also read the official QMK documentation for more information on how to update the keymap. If you run into challenges implementing, please check if there are successful implementations of the same keymap update in the QMK community, and use those as a reference.

The update is a tricky use case so be prepared to help the user troubleshoot and debug their code. The user may have to test the code on their keyboard, so be prepared to help them with that process as well.

## Requirements

- Update the key marked as EDGE_SLASH to contain new functionality.
- When this new key is tapped, it should send the '?' keycode.
- When the key is pressed with the shift modifier, it should send the '!' keycode.
- When the key is held down, it should act as the 'alt' modifier key.
- Make sure that alt is only active while the key is held down, and that it does not interfere with the tap functionality of sending '?' or '!' when the key is tapped.
