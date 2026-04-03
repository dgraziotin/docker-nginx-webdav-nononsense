#!/bin/sh

echo "This utility generates Dockerfiles for stable and mainline versions of nginx when they are released."
echo "It works fully only when you have access to dgraziotin/docker-nginx-webdav-nononsense."

# Fetch the download page once
PAGE=$(/usr/bin/env curl -s http://nginx.org/en/download.html)

# Extract versions by section heading (insert newlines before <h4> to isolate sections)
STABLE_VER=$(echo "$PAGE" | sed 's/<h4>/\n<h4>/g' | sed -n '/Stable version/p' | grep -oE 'nginx-[0-9]+\.[0-9]+\.[0-9]+\.tar\.gz' | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
MAINLINE_VER=$(echo "$PAGE" | sed 's/<h4>/\n<h4>/g' | sed -n '/Mainline version/p' | grep -oE 'nginx-[0-9]+\.[0-9]+\.[0-9]+\.tar\.gz' | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')

if [ -z "$STABLE_VER" ]; then
  echo "ERROR: Could not detect stable nginx version from nginx.org"
  exit 1
fi

if [ -z "$MAINLINE_VER" ]; then
  echo "ERROR: Could not detect mainline nginx version from nginx.org"
  exit 1
fi

echo "Latest stable: ${STABLE_VER}"
echo "Latest mainline: ${MAINLINE_VER}"

# --- Stable ---
echo ""
echo "Checking if nginx-webdav-nononsense exists already for nginx-${STABLE_VER} (stable)"

if /usr/bin/env git tag -l | /usr/bin/env grep -q "^${STABLE_VER}$"; then
  echo "Build exists for nginx-${STABLE_VER}"
  echo "Nothing to be done."
else
  echo "nginx-${STABLE_VER} (stable) is out. Building it."
  echo "Creating a new Dockerfile..."
  /usr/bin/env sed -r "s/%%NGINX_VERSION%%/${STABLE_VER}/g;" Dockerfile.template > Dockerfile

  echo "Committing Dockerfile file ${STABLE_VER}"
  /usr/bin/env git commit -a -m "Dockerfile for stable ${STABLE_VER}"

  echo "Creating a git tag for ${STABLE_VER}"
  /usr/bin/env git tag -a "${STABLE_VER}" -m "stable ${STABLE_VER}"

  echo "Pushing tag ${STABLE_VER}"
  /usr/bin/env git push origin "${STABLE_VER}"
  if [ $? -ne 0 ]; then
    echo "Failing to push tag ${STABLE_VER} for dgraziotin/nginx-webdav-nononsense"
    exit 1
  fi

  echo "Pushing ${STABLE_VER} to main"
  /usr/bin/env git push origin main
  if [ $? -ne 0 ]; then
    echo "Failing to push main for dgraziotin/nginx-webdav-nononsense with ${STABLE_VER}"
    exit 1
  fi
fi

# --- Mainline ---
echo ""
echo "Checking if nginx-webdav-nononsense exists already for nginx-${MAINLINE_VER} (mainline)"

if /usr/bin/env git tag -l | /usr/bin/env grep -q "^${MAINLINE_VER}$"; then
  echo "Build exists for nginx-${MAINLINE_VER}"
  echo "Nothing to be done."
else
  echo "nginx-${MAINLINE_VER} (mainline) is out. Building it."
  echo "Creating a new Dockerfile..."
  /usr/bin/env sed -r "s/%%NGINX_VERSION%%/${MAINLINE_VER}/g;" Dockerfile.template > Dockerfile

  echo "Committing Dockerfile file ${MAINLINE_VER}"
  /usr/bin/env git commit -a -m "Dockerfile for mainline ${MAINLINE_VER}"

  echo "Creating a git tag for ${MAINLINE_VER}"
  /usr/bin/env git tag -a "${MAINLINE_VER}" -m "mainline ${MAINLINE_VER}"

  echo "Pushing tag ${MAINLINE_VER}"
  /usr/bin/env git push origin "${MAINLINE_VER}"
  if [ $? -ne 0 ]; then
    echo "Failing to push tag ${MAINLINE_VER} for dgraziotin/nginx-webdav-nononsense"
    exit 1
  fi

  echo "Pushing ${MAINLINE_VER} to main"
  /usr/bin/env git push origin main
  if [ $? -ne 0 ]; then
    echo "Failing to push main for dgraziotin/nginx-webdav-nononsense with ${MAINLINE_VER}"
    exit 1
  fi
fi
