alias sri='openssl dgst -sha384 -binary | openssl base64 -A | sed -e "s/^/sha384-/;"'
alias uuid16="python -c 'import sys,uuid; sys.stdout.write(uuid.uuid4().hex)' | cut -c1-16 | pbcopy && pbpaste"
alias uuid="python -c 'import sys,uuid; sys.stdout.write(uuid.uuid4().hex)' | pbcopy && pbpaste && echo"

lorem() {
  echo 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.' | pbcopy
  echo Lorem copied to clipboard
}
