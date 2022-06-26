# gandi-ddns
Update Gandi LiveDNS record.

## Download
    git clone https://github.com/pacemoici/gandi-ddns.git

## Run with Docker
This image is based on Alpine Linux and can be run with or without CROND:
- Without CROND (default), the container will execute `gandi-ddns.sh` script and then stop. If you wish to automatically execute this container periodically, you will have to use the host crontab for that (or another solution).
- With CROND, the container will permanently run and execute `gandi-ddns.sh` using the PERIODIC variable to update the container's crontab.

    cp ./etc/gandi-ddns.conf ./gandi-ddns.env

### Without CROND
    docker build -t pacemoici/gandi-ddns:latest .

### With CROND
    docker build -f Dockerfile.cron -t pacemoici/gandi-ddns:latest .

## Run with Systemd
    cp -Rf ./srv/gandi-ddns.sh /usr/local/bin/gandi-ddns
    chmod +x /usr/local/bin/*
    cp -Rf ./etc/* /etc/
    systemctl daemon-reload
    systemctl enable gandi-ddns.service gandi-ddns.timer
    systemctl start gandi-ddns.service gandi-ddns.timer