# Requirements

- Reference ~/.profile to read the environment variable $MACHINE
- The config has been updated, there is now a list of machines for each object
- Only if the current $MACHINE exists for that object, then sync that repository associated with that object
- New, if the local repository path is missing, clone the repository from the remote URL specified in the config, then sync it as normal
