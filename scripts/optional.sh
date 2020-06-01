#!/bin/bash
# This script will download and add domains from the rep to optional-list.txt file.
# Project homepage: https://github.com/lukas-zech-software/whitelist
# Licence: https://github.com/anudeepND/whitelist/blob/master/LICENSE
# Created by Anudeep (Slight change by cminion)
#================================================================================
TICK="[\e[32m ✔ \e[0m]"
PIHOLE_LOCATION="/etc/pihole"
GRAVITY_UPDATE_COMMAND="pihole -w -q"

echo -e " \e[1m This script will download and add domains from the repo to optional-list.txt \e[0m"
echo -e "\n"
echo -e " \e[1m All the domains in this list are safe to add and doesn't contain any tracking or adserving domains. \e[0m"
sleep 1
echo -e "\n"

if [ "$(id -u)" != "0" ] ; then
	echo "This script requires root permissions. Please run this as root!"
	exit 2
fi

curl -sS https://raw.githubusercontent.com/lukas-zech-software/whitelist/master/domains/optional-list.txt | sudo tee -a "${PIHOLE_LOCATION}"/optional-list.txt >/dev/null
echo -e " ${TICK} \e[32m Adding domains to whitelist... \e[0m"
sleep 0.1
echo -e " ${TICK} \e[32m Removing duplicates... \e[0m"
mv "${PIHOLE_LOCATION}"/optional-list.txt "${PIHOLE_LOCATION}"/optional-list.txt.old && cat "${PIHOLE_LOCATION}"/optional-list.txt.old | sort | uniq >> "${PIHOLE_LOCATION}"/optional-list.txt

echo -e " [...] \e[32m Pi-hole gravity rebuilding lists. This may take a while... \e[0m"
${GRAVITY_UPDATE_COMMAND} $(grep -o '^[^#]*' /etc/pihole/optional-list.txt | xargs) > /dev/null
 
echo -e " ${TICK} \e[32m Pi-hole's gravity updated \e[0m"
echo -e " ${TICK} \e[32m Done! \e[0m"

echo -e " \e[1m  Buy me a coffee: https://paypal.me/anudeepND \e[0m"
echo -e " \e[1m  Star me on GitHub, https://github.com/anudeepND/whitelist \e[0m"
echo -e " \e[1m  Happy AdBlocking :)\e[0m"
echo -e "\n\n"