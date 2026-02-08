##################################################
# PATH
##################################################
export PATH="$PATH:/usr/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.tmuxifier/bin"
export PATH="$PATH:$HOME/bin"
export PATH="$PATH:$HOME/go/bin"

##################################################
# CDPATH
##################################################
export CDPATH="$CDPATH:."
export CDPATH="$CDPATH:$HOME"
export CDPATH="$CDPATH:$HOME/Git"

##################################################
# Python Specific
##################################################
if [[ "$MACHINE" =~ ^(work-book|work-book)$ ]]; then
    export PATH="$PATH:$HOME/Library/Python/3.9/bin"
    export PATH="$PATH:$HOME/Library/Python/3.8/bin"
fi

##############################
# Java Specific
##############################
if [ "$MACHINE" = "work-book" ]; then
    export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_202.jdk/Contents/Home
fi

##################################################
# Work Book Specific
##################################################
if [ "$MACHINE" = "work-book" ]; then
    export PATH="$PATH:/usr/local/opt/terraform@0.12/bin"
    export PATH="$PATH:/usr/local/sbin"
    export PATH="$PATH:/usr/sbin"
fi

##################################################
# Steam Deck Specific
##################################################
if [ "$MACHINE" = "steam-deck" ]; then
    export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
fi
