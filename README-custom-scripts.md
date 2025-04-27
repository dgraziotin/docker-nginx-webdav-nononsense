# Custom scripts

Being based on linuxserver.io images, nginx-webdav-nononsense can be extended through [private custom scripts](https://github.com/linuxserver/docker-baseimage-alpine/blob/master/root/etc/s6-overlay/s6-rc.d/init-custom-files/run) within the `/custom-cont-init.d` folder.

Read more about custom scripts here: [https://docs.linuxserver.io/general/container-customization].

Below is an example regarding enabling multi-user support.

## Optional multi-user support

Multi-user support can be setup with only one container. 

Be sure that:
- There is a `htpasswd` file with your users and passwords (more details can be found in [The /config volume](#the-config-volume))
- A folder for each user (named exactly like the username) 
- The right permissions (user/group of the nginx process) for these folders (as set with the env-variable)
- Add a custom-cont-init.d script:
	- Add a new volume in docker-compose: `./custom-cont-init.d:/custom-cont-init.d` (more details can be found in [The /config volume](#the-config-volume))
	- ... with the custom script [`40-user_dir`](custom-cont-init.d/40-user-dir) (from this repository) 
- (Re-)Create the container: `docker-compose up -d --force-recreate nginxwebdav`

The log of the container should contain some information about the custom init-script:
```
cont-init: info: running /etc/cont-init.d/99-custom-files
[custom-init] Files found, executing
[custom-init] 40-user_dir: executing...
change root from /data to /data/$remote_user
[custom-init] 40-user_dir: exited 0
cont-init: info: /etc/cont-init.d/99-custom-files exited 0
```

WebDAV with basic login and custom folders per user tested with the integrated web-client, [Filestash.app](https://github.com/mickael-kerjean/filestash), [Dolphin](https://docs.nextcloud.com/server/20/user_manual/en/files/access_webdav.html#accessing-files-with-kde-and-dolphin-file-manager) (KDE file manager; How-To from NextCloud documentation) and [Linux mount](https://docs.nextcloud.com/server/20/user_manual/en/files/access_webdav.html#creating-webdav-mounts-on-the-linux-command-line) (`davfs`; How-To from NextCloud documentation).