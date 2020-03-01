# Linux Terminal Functions
Bash functions to include into your Linux terminal's config file (.bashrc, .zshrc etc)

## Notes
By now, only Git functions were made. Feel free to write more useful shorthands and make a pull request!

If you have any issues using any function, check if there's already a function defined by another installed library

## Usage
The functions will be available to you at your terminal simple by typing its name.

Example:  ` ~$ gum `

## Installation
- Copy and paste the contents bellow into yours terminal's config file (It will probably be into the home directory (~/))
- Close the terminal and open it again
- That's it :)

## Code
```
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
# up to 3 paremeters are supported, like 'gcm --amend -m "My commit message" '
function gc {
        git commit $1 $2 $3
}

# stashes the changes
function gs {
	git stash $1
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

# show git status minified
function gss {
	git status -s
}

# shows the commit log minified
function glo {
    git log --oneline
}
```
