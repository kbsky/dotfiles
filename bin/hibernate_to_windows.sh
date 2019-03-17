#!/bin/bash
[[ $UID -eq 0 ]] || exec sudo -E "$0" "$@"

echo -e "[Sleep]\nHibernateMode=reboot" > /etc/systemd/sleep.conf.d/hibernate_reboot.conf
bootctl set-oneshot auto-windows
systemctl hibernate
sleep 1s
rm /etc/systemd/sleep.conf.d/hibernate_reboot.conf
