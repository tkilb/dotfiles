# Cmd+V handler: paste text normally, but when the clipboard holds only an
# image, send a raw Ctrl+V so TUIs like slk can read the image themselves
# (slk only checks the clipboard for images on a Ctrl+V keypress).
import os
import subprocess

from kittens.tui.handler import result_handler
from kitty.constants import config_dir

# kitty runs kittens without __file__, so locate the helper via the config dir
CHECK_SCRIPT = os.path.join(config_dir, 'clipboard_image.js')


def main(args):
    pass


def clipboard_has_only_image():
    try:
        out = subprocess.run(['osascript', '-l', 'JavaScript', CHECK_SCRIPT],
                             capture_output=True, text=True, timeout=2).stdout
    except (OSError, subprocess.SubprocessError):
        return False
    return out.strip() == 'image'


@result_handler(no_ui=True)
def handle_result(args, answer, target_window_id, boss):
    window = boss.window_id_map.get(target_window_id)
    if window is not None and clipboard_has_only_image():
        window.send_key('ctrl+v')
    else:
        boss.paste_from_clipboard()
