# README

[docker-nginx-webdav-nononsense](https://github.com/dgraziotin/docker-nginx-webdav-nononsense) aims to be a Docker image that enables a no-nonsense WebDAV system on the latest available nginx, stable and mainline.

The image, and resulting container, is designed to run behind a reverse proxy (e.g., the great [jc21/nginx-proxy-manager](https://github.com/jc21/nginx-proxy-manager)) to handle SSL. So, it runs on port 80 internally.

## Why no-nonsense?

I'm taking it lightly: my own project is no-nonsense to me ;-) there is nothing wrong with other projects.

Here is what I think sets it apart from other nginx Docker images.

- Based on [linuxserver.io](https://linuxserver.io) Ubuntu. All their magic is here, too, including their handling of user and group permission.
  - Now with a working `/config` volume (see below).
- Takes inspiration from [Rob Peck instructions to make WebDAV working well on nginx](https://www.robpeck.com/2020/06/making-webdav-actually-work-on-nginx/), which brings the following goodies:
  1. Includes the latest [nginx-dav-ext-module](https://github.com/arut/nginx-dav-ext-module) (enables PROPFIND, OPTIONS, LOCK, UNLOCK).
  2. Includes the latest [headers-more-nginx-module](https://github.com/openresty/headers-more-nginx-module) to handle broken and weird clients.
  3. Includes the latest [ngx-fancyindex](https://github.com/aperezdc/ngx-fancyindex) to make directory listing look good.
- No more [NSPOSIXErrorDomain:100 Error](https://megamorf.gitlab.io/2019/08/27/safari-nsposixerrordomain-100-error-with-nginx-and-apache/) with Safari 14+ on MacOS and on iOS 14+.
- Works out of the box with [jc21/nginx-proxy-manager](https://github.com/jc21/nginx-proxy-manager), no "Advanced" configuration needed, no `proxy_hide_header Upgrade;` needed.
- Works out of the box with macOS Finder.
- Works out of the box with Microsoft Windows Explorer (tested on Windows 11) [with fixes](http://netlab.dhis.org/wiki/ru:software:nginx:webdav) adapted from [rozhuk-im](https://github.com/rozhuk-im).
- CORS headers are all set.
- Some good configuration settings are automatized through env variables (see below).

# Settings

Mount any of these two volumes:

- `./path/to/dir:/data` is the root folder that nginx will serve for WebDAV content (`/data`).
- `./config:/config` contains useful configuration files for nginx as well as the overall container. If you mount `/config` to an empty folder, the folder will be initialized with default empty files that you will be able to edit. See the next section for more information.

These are environment variables you can set, and what they do.

- `PUID=1000` user id with read/write access to `./path/to/dir:/data` volume. Nginx will use the same to be able to read/write to the folder.
- `PGID=1000` group id with read/write access to `./path/to/dir:/data` volume. Nginx will use the same to be able to read/write to the folder.
- `TZ=Europe/Berlin` specifies timezone for the underlying GNU/Linux system.
- `WEBDAV_USERNAME=user` to set a single username to access WebDAV. Ignored if `WEBDAV_PASSWORD`is not set, ignored if `/config/nginx/htpasswd` is provided.
- `WEBDAV_PASSWORD=password` to set the password to the single username to access WebDAV. Ignored if `WEBDAV_USERNAME`is not set, ignored if `/config/nginx/htpasswd` is provided.
- `SERVER_NAMES=localhost,ineed.coffee` comma separated hostnames for the server. 
- `TIMEOUTS_S=1200` expressed as seconds, sets at the same time various nginx timeouts: `send_timeout`, `client_body_timeout`, `keepalive_timeout`, `lingering_timeout`.
- `CLIENT_MAX_BODY_SIZE=120M` limits file upload size to the expressed value, which must end wither with `M`(egabytes) or `G`(igabytes).

## The /config volume

The container path `/config` is configured as unnamed/anonymous volume. Besides that, it contains the following paths and files:

- `/config/custom-cont-init.d` to host [your own custom scripts that run at startup](https://www.linuxserver.io/blog/2019-09-14-customizing-our-containers#custom-scripts).
- `/config/custom-services.d` to host [your own service files](https://www.linuxserver.io/blog/2019-09-14-customizing-our-containers#custom-services).
- `/config/nginx` to host custom configuration files for nginx, namely:
  - `/config/nginx/http.conf` included at the end of nginx.conf http directive.
  - `/config/nginx/server.conf` included at the end of nginx.conf server directive.
  - `/config/nginx/http.conf` included at the end of nginx.conf location directive.

Furthermore, if you provide an htpasswd file at `/config/nginx/htpasswd`, the container will use it for authentication.
Tha htpasswd is the [Apache HTTP compatible flat file to register usernames and passwords](https://httpd.apache.org/docs/2.4/programs/htpasswd.html). If you provide one, you can tell the container who your username and passwords are. 
Please note that providing an htpasswd file will make the container ignore any supplied env variable `WEBDAV_USERNAME` and `WEBDAV_PASSWORD`.
Please note that all users have the same access levels.
Removing the file at `/config/nginx/htpasswd` will cause the container to use any provided `WEBDAV_USERNAME` and `WEBDAV_PASSWORD` variables.

# Usage

- Clone this repository, edit the included docker-compose.yml, and run `docker-compose build && docker-compose up` to build and run the container. Access it from http://localhost:32080; or
- Build the Dockerfile and run the container with docker; or
- Pull and run my docker image [dgraziotin/nginx-webdav-nononsense](https://hub.docker.com/r/dgraziotin/nginx-webdav-nononsense) and use it with docker-compose or docker.

If you are using a reverse proxy (you should!), and the reverse proxy is containerized, do not forget to connect the container to the reverse proxy with a network. Follow the instructions of your reverse proxy.

With [jc21/nginx-proxy-manager](https://github.com/jc21/nginx-proxy-manager), I add the following to the docker-compose.yml:

```
networks:
    default:
       external:
         name: reverseproxy
```

Consider also un-exposing the port if you use a reverse proxy.

Kindly note that this project is proxy-independent and requires you to be knowledgeable about reverse proxy to be used properly. 

A reverse proxy, if misconfigured, could become the weaker link that prevents proper functioning of the WebDAV functionalities. 

Examples include having the reverse configured with values for timeouts or max body size  that are less than the one nginx-webdav-nononsense uses. 

Some proxies might not forward important headers from-and-to nginx-webdav-nononsense, and you may need to whitelist these headers manually. Finally, a reminder that Cloudfare is a reverse proxy with its settings and limitations ([example](https://community.cloudflare.com/t/does-the-100-mb-limit-apllies-to-all-users-on-my-website/297261/4)), some of which cannot be changed.

# Feature requests

I will add features if I happen to need them. To name one, I do not need native SSL support, because I use a reverse proxy.
However, I welcome pull requests.

# Credits

Many thanks to [dotWee](https://github.com/dotWee) for adding awesome CI features to the repo!
