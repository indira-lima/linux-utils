# Copy and paste the code into your bash configuration file

alias upd='docker-compose up -d'
alias down='docker-compose down'

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
    git config --global alias.lo 'log --oneline' &&
    git config --global alias.pm 'pull origin master' &&
    git config --global alias.go 'checkout' &&
    git config --global alias.gm 'go master' &&
    git config --global alias.pho "push origin $(git branch --show-current)" &&
    git config --global alias.plo "pull origin $(git branch --show-current)"

    echo 'Git aliases set successfully'
}