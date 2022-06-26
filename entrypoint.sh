#!/bin/sh

if [ -z "${PERIODIC}" ]; then
    printf 'crond: PERIODIC is required!\n\n' >&2
    exit 1
fi

case "${PERIODIC}" in
  15min)
    printf 'crond: gandi-ddns will be renewed every 15 min.\n'
    printf '0/15    *       *       *       *       gandi-ddns.sh\n' >> '/etc/crontabs/root'
    ;;
  30min)
    printf 'crond: gandi-ddns will be renewed every 30 min.\n'
    printf '0/30    *       *       *       *       gandi-ddns.sh\n' >> '/etc/crontabs/root'
    ;;
  hourly)
    printf 'crond: gandi-ddns will be renewed every hour.\n'
    printf '0       *       *       *       *       gandi-ddns.sh\n' >> '/etc/crontabs/root'
    ;;
  daily)
    printf 'crond: gandi-ddns will be renewed every day at 2:00a.m..\n'
    printf '0       2       *       *       *       gandi-ddns.sh\n' >> '/etc/crontabs/root'
    ;;
  *)
    printf 'crond: PERIODIC is invalid.\n' >&2
    printf '       One of: "15min", "30min", "hourly" (default), "daily" (not recommended).\n' >&2
    printf '\n' >&2
    exit 1
    ;;
esac

/usr/sbin/crond -f -l 2