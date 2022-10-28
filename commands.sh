
# Copy and paste the code into your bash configuration file

alias cdcd='cd ~/Documents/code'
alias h='history'
alias v='vim'
alias rr='ranger'
alias s='source ~/.zshrc'
alias cm='cmatrix'
alias upd='docker-compose up -d'
alias down='docker-compose down'
alias start-emulator='player --vm-name "Custom Phone"'
alias open='xdg-open'

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
		mkdir $1 && cd $1
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

# Updates the branch master from the origin remote
function gum {
	git stash
	git checkout master
	git pull origin master
}

# merges the branch master into the current branch
function gmm {
	git merge master
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
	echo "git pm -> git pull origin master"
    git config --global alias.pm 'pull origin master' &&
	echo "git go -> git checkout"
    git config --global alias.go 'checkout' &&
	echo "git gm -> git go master"
    git config --global alias.gm 'go master'
	echo
    echo 'Git aliases set successfully'
}

