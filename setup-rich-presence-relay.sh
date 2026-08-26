#!/usr/bin/zsh

EXE='npiperelay.exe'

export GOOS=windows
export GOARCH=amd64

GO_BIN="$(/usr/local/go/bin/go env GOPATH)/bin/${GOOS}_${GOARCH}"

msg () {
    text=$2

    case $1 in
        'success')
            symbol="*"
            ;;
        'error')
            symbol="!"
            ;;
        *)
            symbol="+"
            text=$1
    esac

    echo "[$symbol] $text"
}

if [[ $EUID > 0 ]]; then
    msg 'error' 'This script must be run as root! Exiting...'
    exit 1
fi

msg 'Cross-compiling npiperelay...'

# Do a cross-compile install of npiperelay using GOOS/GOARCH.
/usr/local/go/bin/go install github.com/jstarks/npiperelay@latest

# Move the executable to the PATH.
mv $GO_BIN/$EXE /usr/bin/$EXE

msg "Creating 'discord' group..."

# Create the 'discord' group to limit who can read/write on the IPC pipe.
groupadd discord
usermod -aG discord $SUDO_USER

msg 'Adding discord-ipc.service...'

# Create the systemd service.
cat << EOF > /etc/systemd/system/discord-ipc.service
[Unit]
Description=Relay Discord IPC in WSL
[Service]
Type=simple
ExecStart=socat UNIX-LISTEN:/var/run/discord-ipc-0,fork,group=discord,umask=007 EXEC:"/usr/bin/$EXE -ep -s //./pipe/discord-ipc-0",nofork
RemainAfterExit=yes
[Install]
WantedBy=multi-user.target
EOF

# Finally, enable the service.
systemctl enable discord-ipc

msg 'success' 'Rich Presence relay is now installed!'
msg 'success' "To start the service, run 'sudo systemctl start discord-ipc' or reboot WSL2 with 'wsl --shutdown; wsl'."
msg 'success' 'A relogin is required for group changes to take effect.'
