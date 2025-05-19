cat << EOF >> ~/.ssh/config

Host ${hostname}
    HostName ${hostname}
    user ${user}
    IdentifyFile ${identifyfile}
EOF