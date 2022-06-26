#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

function get_rrset_value
{
    curl \
        --header 'Content-Type: application/json' \
        --header "Authorization: Apikey ${API_KEY}" \
        --request GET \
        --silent \
        "https://api.gandi.net/v5/livedns/domains/${FQDN}/records/${RRSET_NAME}/${RRSET_TYPE}" \
    | jq --raw-output '.rrset_values[0]'
}

function update_rrset_value
{
    curl \
        --dump-header - \
        --header 'Content-Type: application/json' \
        --header "Authorization: Apikey ${API_KEY}" \
        --data \
            "{ \
                \"rrset_name\":\"${RRSET_NAME}\", \
                \"rrset_type\":\"${RRSET_TYPE}\", \
                \"rrset_ttl\":${RRSET_TTL}, \
                \"rrset_values\":[\"${ADDRESS}\"] \
            }" \
        --request PUT \
        --silent \
        "https://api.gandi.net/v5/livedns/domains/${FQDN}/records/${RRSET_NAME}/${RRSET_TYPE}"
}

if [ -z "${API_KEY}" ]; then
    printf 'gandi-ddns: API_KEY is required!\n' >&2
    printf '\n' >&2
    exit 1
fi

if [ -z "${FQDN}" ]; then
    printf 'gandi-ddns: FQDN is required!\n' >&2
    printf '            Value must respect ''domain.tld'' format.\n' >&2
    printf '\n' >&2
    exit 1
fi

if [ -z "${RRSET_NAME}" ]; then
    printf 'gandi-ddns: RRSET_NAME is required!\n' >&2
    printf '\n' >&2
    exit 1
fi

if [ -z "${RRSET_TYPE}" ]; then
    printf 'gandi-ddns: RRSET_TYPE is required!\n' >&2
    printf '            One of: "A", "AAAA", "ALIAS", "CAA", "CDS",\n' >&2
    printf '            "CNAME", "DNAME", "DS", "KEY", "LOC", "MX",\n' >&2
    printf '            "NAPTR", "NS", "OPENPGPKEY", "PTR", "RP",\n' >&2
    printf '            "SPF", "SRV", "SSHFP", "TLSA", "TXT", "WKS".\n' >&2
    printf '\n' >&2
    exit 1
fi

if [ -z "${RRSET_TTL}" ]; then
    printf 'gandi-ddns: RRSET_TTL is invalid!\n' >&2
    printf '            Minimum: 300\n' >&2
    printf '            Maximum: 2592000\n' >&2
    printf '\n' >&2
    exit 1
fi

if [ -z "${MY_IP}" ]; then
    printf 'gandi-ddns: MY_IP is invalid!\n' >&2
    printf '\n' >&2
    exit 1
fi

readonly ADDRESS="$(curl --silent "${MY_IP}")"
readonly RRSET_VALUE="$(get_rrset_value)"

if [ "${ADDRESS}" != "${RRSET_VALUE}" ]; then
    update_rrset_value > /dev/null 2>&1
    printf 'gandi-ddns: Record %s.%s has been updated to %s.\n' "'${RRSET_NAME}" "${FQDN}'" "'${ADDRESS}'"
fi