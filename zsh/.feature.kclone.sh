kclone() {
    local user="tkilb"

    if [ -z "$1" ]; then
        echo "Usage: kclone <repository-name>"
        return 1
    fi

    git clone "git@github.com:$user/$1.git"
}
