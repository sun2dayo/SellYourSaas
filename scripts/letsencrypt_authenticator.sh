#!/bin/bash
#-------------------------------------------
# A manual hook for letsencrypt renewal with DNS
#-------------------------------------------

#LET'S ENCRYPT VARIABLES
#
#CERTBOT_DOMAIN: The domain being authenticated
#CERTBOT_ALL_DOMAINS: A comma-separated list of all domains challenged for the current certificate
#CERTBOT_VALIDATION: The validation string
#CERTBOT_TOKEN: Resource name part of the HTTP-01 challenge (HTTP-01 only)
#CERTBOT_REMAINING_CHALLENGES: Number of challenges remaining after the current challenge

verbose=true
echo ----- letsencrypt_authenticator.sh -----
echo "CERTBOT_DOMAIN=$CERTBOT_DOMAIN"
echo "CERTBOT_ALL_DOMAINS=$CERTBOT_ALL_DOMAINS"
echo "CERTBOT_VALIDATION=$CERTBOT_VALIDATION"
echo "CERTBOT_REMAINING_CHALLENGES=$CERTBOT_REMAINING_CHALLENGES"

# Sanitize input data
CERTBOT_DOMAIN=$(echo $CERTBOT_DOMAIN | tr -cd '[:alnum:][_\-][\.]')
CERTBOT_VALIDATION=$(echo $CERTBOT_VALIDATION | tr -cd '[:alnum:][_\-]')
CERTBOT_REMAINING_CHALLENGES=$(echo $CERTBOT_REMAINING_CHALLENGES | tr -cd '[:alnum:][_\-]')

export subdomain=$CERTBOT_DOMAIN
if [[ "x$subdomain" == "x" ]]; then
        export subdomain=`grep '^subdomain=' /etc/sellyoursaas.conf | cut -d '=' -f 2`
fi
# Sanitize variable
subdomain=${subdomain//[^a-zA-Z0-9.-]/}

zone_file="/etc/bind/${subdomain}.hosts"
echo "zone_file=$zone_file"

if [ -z "$CERTBOT_DOMAIN" ] || [ -z "$CERTBOT_VALIDATION" ]; then
    echo "EMPTY DOMAIN OR VALIDATION : LET'S ENCRYPT ENV VARIABLES NOT SET"
    exit 2
fi

if [ ! -f "$zone_file" ] || [ ! -w "$zone_file" ]; then
    echo "ZONE FILE DOESN'T EXIST OR ISN'T WRITABLE: $zone_file"
    exit 3
fi

# Get the current serial
old_serial=$(grep serial $zone_file | awk '{print $1}' | tr -cd '[:alnum:][_\-]')
new_serial=$((old_serial+1))

# Log the current and new challenges
$verbose && echo "old serial : $old_serial"
$verbose && echo "new serial : $new_serial"

# Append the new TXT record without removing the previous one
echo "_acme-challenge.${CERTBOT_DOMAIN}. IN TXT \"${CERTBOT_VALIDATION}\"" >> $zone_file

# Update the serial number
sed -i.auto.bck -e "s/$old_serial/$new_serial/" $zone_file

# Restart BIND to apply changes
systemctl restart bind9

# Sleep to allow propagation (adjust this time if necessary)
sleep 15
