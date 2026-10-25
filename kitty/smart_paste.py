# Smart paste handler: paste text normally, but when the clipboard holds only an
# image, send a raw Ctrl+V so TUIs like slk and concord can read the image themselves
# (slk and concord only check the clipboard for images on a Ctrl+V keypress).
import os
import shutil
import subprocess
import sys

from kittens.tui.handler import result_handler
from kitty.constants import config_dir

# kitty runs kittens without __file__, so locate the helper via the config dir
CHECK_SCRIPT = os.path.join(config_dir, 'clipboard_image.js')


def main(args):
    pass


def _clipboard_has_only_image_darwin():
    try:
        out = subprocess.run(['osascript', '-l', 'JavaScript', CHECK_SCRIPT],
                             capture_output=True, text=True, timeout=2).stdout
    except (OSError, subprocess.SubprocessError):
        return False
    return out.strip() == 'image'


def _clipboard_has_only_image_linux():
    if shutil.which('wl-paste'):
        try:
            res = subprocess.run(['wl-paste', '--list-types'],
                                 capture_output=True, text=True, timeout=1)
            if res.returncode == 0:
                types = [line.strip() for line in res.stdout.splitlines() if line.strip()]
                has_image = any(t.startswith('image/') for t in types)
                has_text = any(t.startswith('text/') or t in ('UTF8_STRING', 'STRING', 'TEXT') for t in types)
                return has_image and not has_text
        except (OSError, subprocess.SubprocessError):
            pass

    if shutil.which('xclip'):
        try:
            res = subprocess.run(['xclip', '-selection', 'clipboard', '-t', 'TARGETS', '-o'],
                                 capture_output=True, text=True, timeout=1)
            if res.returncode == 0:
                types = [line.strip() for line in res.stdout.splitlines() if line.strip()]
                has_image = any(t.startswith('image/') for t in types)
                has_text = any(t.startswith('text/') or t in ('UTF8_STRING', 'STRING', 'TEXT') for t in types)
                return has_image and not has_text
        except (OSError, subprocess.SubprocessError):
            pass

    return False


def clipboard_has_only_image():
    if sys.platform == 'darwin':
        return _clipboard_has_only_image_darwin()
    if sys.platform.startswith('linux'):
        return _clipboard_has_only_image_linux()
    return False


@result_handler(no_ui=True)
def handle_result(args, answer, target_window_id, boss):
    window = boss.window_id_map.get(target_window_id)
    if window is not None and clipboard_has_only_image():
        window.send_key('ctrl+v')
    else:
        boss.paste_from_clipboard()
