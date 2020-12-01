#!/usr/bin/with-contenv bash

# Configure vhosts.
# inspired from (= copy paste) from https://github.com/BytemarkHosting/docker-webdav
if [ "x$SERVER_NAMES" != "x" ]; then
    # Replace commas with spaces
    SERVER_ALIAS="`printf '%s\n' "$SERVER_NAMES" | tr ',' ' '`"
    sed -i "s/localhost/$SERVER_ALIAS/g" /etc/nginx/nginx.conf
fi

# Add password hash, unless /etc/nginx/htpasswd already exists (ie, bind mounted).
if [ ! -e "/etc/nginx/htpasswd" ]; then
  touch "/etc/nginx/htpasswd"
  if [ "x$WEBDAV_USERNAME" != "x" ] && [ "x$WEBDAV_PASSWORD" != "x" ]; then
    htpasswd -bc /etc/nginx/htpasswd $WEBDAV_USERNAME $WEBDAV_PASSWORD
    # root /data/$remote_user;
  else
    # no auth
    sed -i 's%auth_basic "Restricted";% %g' /etc/nginx/nginx.conf
    sed -i 's%auth_basic_user_file htpasswd;% %g' /etc/nginx/nginx.conf
  fi
fi