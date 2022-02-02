# Linux Utils

## `commands.sh`

Bash commands to include into your Linux terminal's config file (.bashrc, .zshrc etc)

### Notes

By now, only Git and Docker commands were made. Feel free to write more useful shorthands and make a pull request!

If you have any issues using any function, check if there's already a function defined by another installed library

### Usage

The commands will be available to you at your terminal simple by typing its name.

Example:  ` ~$ gum `

### Installation

If you run the `configure_ubuntu.sh` script for automatically install some useful apps, it will paste the code within `commands.sh` into your ~/.zshrc (it will also intall zsh and make it your default shell using Oh-My-Zsh and Powerlevel10k)

If you just want the commands, follow these steps:

- Copy and paste the contents of `commands.sh` into yours shell's config file (`~/.bashrc`, `~/.zshrc` or equivalent)
- Close the terminal and open it again
- That's it :)

---

## `configure_ubuntu.sh`

A script for automatically download necessary apps into a newly installed Ubuntu distro

The configuration was made for my personal laptop and includes my favorite apps.
To run it, just clone the repository, go to the folder and give the file `configure_ubuntu.sh` execute permitions with:

`sudo chmod +x configure_ubuntu.sh`

And run the script by just typing its name into the terminal:

`./configure_ubuntu.sh`

**IMPORTANT DISCLAIMER:** I **DO NOT** make myself responsible for any issues that the script causes into your computer.
Please note that it's a homemade configuration file that downloads some apps and files to your system, therefore
it may cause some unwanted results depending on your environment. I strongly recommend that you read the script and do any
necessary changes at your will, just make sure that it wont install anything that you do not desire.
