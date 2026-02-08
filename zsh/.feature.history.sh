if [[ -z ${_backHistory} ]] then; export _backHistory=(''); fi;
if [[ -z ${_forwardHistory} ]] then; export _forwardHistory=(''); fi;

cd() {
    if [[ $? == 0 ]]; then
        _backHistory=($(pwd -P) "${_backHistory[@]}")
        _forwardHistory=''
    fi
    builtin cd $1
}
_back() {
    if [[ -n ${_backHistory[1]} ]] then;
        _forwardHistory=($(pwd -P) "${_forwardHistory[@]}")
        builtin cd ${_backHistory[1]}
    else
        echo 'No previous cd...'
    fi
    _backHistory=("${_backHistory[@]:1}")
}
alias -- -=_back

_forward() {
    if [[ -n ${_forwardHistory[1]} ]] then;
        _backHistory=($(pwd -P) "${_backHistory[@]}")
        builtin cd ${_forwardHistory[1]}
    else
        echo 'No future cd...'
    fi
    _forwardHistory=("${_forwardHistory[@]:1}")
}
alias -- +=_forward

hist() {
    [ -z "$2" ] && history | grep ${1-''} | tail -n 10 || history | grep ${1-''} | tail -n $2
}

alias h='hist'

