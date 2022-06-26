# Dockerfile: gandi-livedns
# Update Gandi LiveDNS record.

FROM        alpine:latest

# Gandi-DDNS environment variables.
ENV         API_KEY='' \
            FQDN='' \
            MY_IP='http://ifconfig.me/ip' \
            RRSET_NAME='' \
            RRSET_TYPE='A' \
            RRSET_TTL=3600

COPY        ./src/gandi-ddns.sh          /gandi-ddns

RUN         apk --update --no-cache add bash curl jq \
            && chmod +x /gandi-ddns

ENTRYPOINT  [ "/gandi-ddns" ]