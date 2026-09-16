
# Copy and paste the code into your bash configuration file

DIRNAME=$(dirname $0)

export PATH="$PATH:$DIRNAME"

# echo "checking for user defined alises in $DIRNAME/.aliases"
if [ -f "$DIRNAME/.aliases" ]; then
	# echo "sourcing user defined aliases"
	source "$DIRNAME/.aliases"
fi

alias h='history'
alias v='nvim'
alias nv='nvim'
# alias rr='. ranger' # cd para o diretório que o ranger estava quando sair
alias s='source ~/.zshrc'
alias cm='cmatrix'
alias open='xdg-open'
# alias bat='batcat'
# alias ls='exa'
alias unblock-bluetooth='rfkill unblock all'
alias less='less -R'
alias grep='grep --color=always'
alias rpo='sudo rpm-ostree'
alias ff='fastfetch'
alias of='onefetch'
alias go='cd-onefetch'
alias qdbus6='qdbus'

function rr {
	tmp="$(mktemp)"
	ranger --choosedir="$tmp" "$@"
	if [ -f "$tmp" ]; then
	dir="$(cat "$tmp")"
	rm -f "$tmp"
	[ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && go "$dir"
	fi
}

function cd-onefetch {
	cd $1 && onefetch 2> /dev/null
}

# uses recordmydesktop to save a timelapse video on ~/Videos/name.ogv
# name can be especified in arguments (timelapse myVideo)
function timelapse {

    FILE="/home/$(whoami)/Videos/${1:-desktop_recording}.ogv"

    echo "Starting recordmydesktop. Abort with Ctrl-C."
    recordmydesktop --no-sound --on-the-fly-encoding --workdir /var/temp -o "$FILE"
    echo "Stopped."
}

function mkdircd {
	if [ -n "$1" ]; then
		mkdir -p $1 && cd $1
	else
		print "Usage: mkdircd <directory>"
	fi
}

# checks the sha256 sum of a file
function sha256 {
    if [ -n "$1" ]; then
        echo "$(cat "$1.sha256sum" | sed 's/\s.*//g') $1" | sha256sum --check
    else
	echo "[sha256] Usage: sha256 <file_to_check> # note that there's must be a <file_to_check>.sha256sum file in the same directory"
    fi
}

# open iterative terminal for a docker container
function dexec {
	if [ -n "$1" ]
	then
		docker exec -it {$1} sh
	else
   		print '[Docker exec] Usage: dexec <container>'
	fi
}

# Updates the branch main from the origin remote
function gum {
	git stash -u -m "gum: alterações guardadas"
	git checkout main
	git pull origin main
}

# merges the branch main into the current branch
function gmm {
	git merge main
}

# commits the staged changes
# up to 3 parameters are supported, like 'gcm --amend -m "My commit message" '
function gc {
        git commit $1 $2 $3
}

# stashes the changes
function gs {
	git stash $1 $2 $3
}

# applies the stashed changes
# to apply another stash instead of the last,
# type "gsa n", where 'n' is the number of the stash
# Ex.: "gsa 2" will run "git stash apply stash@{2}"
function gsa {
	if [ -n "$1" ]
	then
		git stash apply stash@{$1}
	else
		git stash apply
	fi
}

# pops the stashed changes
# to pop another stash instead of the last,
# type "gsa n", where 'n' is the number of the stash
# Ex.: "gsa 2" will run "git stash pop stash@{2}"
function gsp {
	if [ -n "$1" ]
	then
		git stash pop stash@{$1}
	else
		git stash pop
	fi
}

# show git status minified
function gss {
	git status -s
}

# shows the commit log minified
function glo {
    git log --oneline
}

function set_git_aliases {
	echo "Setting git aliases"
	echo
	echo "git lo -> git log --oneline"
    git config --global alias.lo 'log --oneline' &&
	echo "git pm -> git pull origin main"
    git config --global alias.pm 'pull origin main' &&
	echo "git go -> git checkout"
    git config --global alias.go 'checkout' &&
	echo "git gm -> git go main"
    git config --global alias.gm 'go main'
	echo "git fa -> git fetch all"
    git config --global alias.fa 'fetch -v --all'
	echo "git bl -> git branch -l"
    git config --global alias.bl 'branch -l'
	echo "git ss -> git status -s"
    git config --global alias.ss 'status -s'
	echo
    echo 'Git aliases set successfully'
}

check_array() {
    local name=$1

    if (( $# != 1 )); then
        print -u2 "usage: check_array array_name"
        return 2
    fi

    if (( ${+parameters[$name]} )) &&
       [[ ${(tP)name} == array* ]]; then
        return 0
    fi

    return 1
}

get_random_index() {
    if (( $# != 1 )); then
        print -u2 "usage: get_random_index indexed_array"
        return 2
    fi

    local name=$1

    if ! check_array "$name"; then
        print -u2 "$name is not an indexed array"
        return 1
    fi

    # Indirectly copy the named array into a local array.
    local -a values
    values=( "${(@P)name}" )

    if (( ${#values} == 0 )); then
        print -u2 "$name is empty"
        return 1
    fi

    local random_index
    (( random_index = RANDOM % ${#values} + 1 ))

    print -r -- "${values[$random_index]}"
}

switch_kde_activity() {
    local activity_name=$1
    local activity_hash

    activity_hash=$(
        kactivities-cli --list-activities |
        awk -v name="$activity_name" '$3 == name { print $2; exit }'
    )

    if [[ -z $activity_hash ]]; then
        print -u2 "Activity not found: $activity_name"
        return 1
    fi

    kactivities-cli --set-current-activity "$activity_hash"
}

alo() {
	notify-send $1 -u critical
}
