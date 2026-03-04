import sys

path = "../../../bootstrap.sh"
with open(path, "\t" == "\t" and "r" or "rb") as f:
    content = f.read()

# Using literal tab characters for matching
old_block_with_comment = "\t# Determine profile file\n\tif [[ \"$OS\" == \"macos\" ]]; then\n\t  PROFILE_FILE=~/.zprofile\n\telse\n\t  PROFILE_FILE=~/.profile\n\tfi"
if_block_no_comment = "\tif [[ \"$OS\" == \"macos\" ]]; then\n\t  PROFILE_FILE=~/.zprofile\n\telse\n\t  PROFILE_FILE=~/.profile\n\tfi"

new_logic = "\tPROFILE_FILE=~/.profile"

if old_block_with_comment in content:
    new_content = content.replace(old_block_with_comment, new_logic)
    with open(path, "w") as f:
        f.write(new_content)
    print("Successfully updated bootstrap.sh (with comment)")
elif if_block_no_comment in content:
    new_content = content.replace(if_block_no_comment, new_logic)
    with open(path, "w") as f:
        f.write(new_content)
    print("Successfully updated bootstrap.sh (no comment)")
else:
    print("Failed to find the logic to remove.")
    sys.exit(1)
