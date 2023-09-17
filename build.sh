#!/bin/sh

echo "This utility generates Dockerfiles for stable and mainline versions of nginx when they are released."
echo "It works fully only when you have access to dgraziotin/docker-nginx-webdav-nononsense."

echo "Searching for latest nginx stable on nginx.org"

NGINX_VER=$(/usr/bin/env curl -v --silent http://nginx.org/en/download.html 2>&1 | grep tar.gz | grep -Eo '\d+\.\d+\.\d+' | awk 'FNR == 7 {print}')

echo "Checking if nginx-webdav-nononsense exists already for nginx-${NGINX_VER}"

if /usr/bin/env git tag -l | /usr/bin/env grep "${NGINX_VER}"; then
  echo "Build exists for nginx-${NGINX_VER}"
  echo "Nothing to be done."
else
  echo "nginx-${NGINX_VER} (stable) is out. Building it."
  echo "Creating a new Dockerfile..."
  /usr/bin/env sed -r "s/%%NGINX_VERSION%%/${NGINX_VER}/g;" Dockerfile.template > Dockerfile

  echo "Committing Dockerfile file ${NGINX_VER}"
  /usr/bin/env git commit -a -m "Dockerfile for stable ${NGINX_VER}"

  echo "Creating a git tag for ${NGINX_VER}"
  /usr/bin/env git tag -a "${NGINX_VER}" -m "stable ${NGINX_VER}"

  echo "Pushing tag ${NGINX_VER}"
  /usr/bin/env git push origin "${NGINX_VER}"
  if [ $? -ne 0 ]; then
    echo "Failing to push tag ${NGINX_VER} for dgraziotin/nginx-webdav-nononsense"
    exit 1
  fi

  echo "Pushing ${NGINX_VER} to master"
  /usr/bin/env git push origin main
  if [ $? -ne 0 ]; then
    echo "Failing to push master for dgraziotin/nginx-webdav-nononsense with ${NGINX_VER}"
    exit 1
  fi
  
fi

echo "Searching for latest nginx mainline on nginx.org"

NGINX_VER=$(/usr/bin/env curl -v --silent http://nginx.org/en/download.html 2>&1 | grep tar.gz | grep -Eo '\d+\.\d+\.\d+' | awk 'FNR == 1 {print}')

echo "Checking if nginx-webdav-nononsense exists already for nginx-${NGINX_VER}"

if /usr/bin/env git tag -l | /usr/bin/env grep "${NGINX_VER}"; then
  echo "Build exists for nginx-${NGINX_VER}"
  echo "Nothing to be done."
else
  echo "nginx-${NGINX_VER} (mainline) is out. Building it."
  echo "Creating a new Dockerfile..."
  /usr/bin/env sed -r "s/%%NGINX_VERSION%%/${NGINX_VER}/g;" Dockerfile.template > Dockerfile

  echo "Committing Dockerfile file ${NGINX_VER}"
  /usr/bin/env git commit -a -m "Dockerfile for mainline ${NGINX_VER}"

  echo "Creating a git tag for ${NGINX_VER}"
  /usr/bin/env git tag -a "${NGINX_VER}" -m "mainline ${NGINX_VER}"

  echo "Pushing tag ${NGINX_VER}"
  /usr/bin/env git push origin "${NGINX_VER}"
  if [ $? -ne 0 ]; then
    echo "Failing to push tag ${NGINX_VER} for dgraziotin/nginx-webdav-nononsense"
    exit 1
  fi

  echo "Pushing ${NGINX_VER} to master"
  /usr/bin/env git push origin main
  if [ $? -ne 0 ]; then
    echo "Failing to push master for dgraziotin/nginx-webdav-nononsense with ${NGINX_VER}"
    exit 1
  fi
fi
