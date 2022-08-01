---
name: Bug report
about: Create a report to help us improve
title: ''
labels: bug
assignees: dgraziotin

---

**Describe the bug**
A clear and concise description of what the bug is.

Please include the exact error messages that your client is reporting.

**To Reproduce**
Steps to reproduce the issue:

1. ...
2. ...
3. ...

**Expected behavior**
A clear and concise description of what you expected to happen instead of the issue.

**How do you use nginx-webdav-nononsense (please complete the following information):**
 - Version: [e.g. 1.22.0] **if you are not using the latest released stable or mainline versions, please try to update to them before reporting the bug**
 - Did you build the image yourself?: [e.g. no / yes with these modifications]
 - How do you start the container? [e.g. `docker container run ....` / with the docker-compose.yml pasted here]
- How do you access the container? [e.g. directly / with this reverse proxy ...]
 - Do you use a custom nginx.conf? [e.g. no / yes and pasted here]

**WebDAV client information (please complete the following information):**
 - OS: [e.g. macOS 12.5]
 - WebDAV client name: [e.g. Mountain Duck]
 - Version [e.g. 4.12.1]

**nginx log**

The logs are accessible with `docker-compose logs` where your docker-compose.yml is, or with `docker container logs container_name`.

Paste below, between the two sets of triple back quotes, 4-5 log lines before the issue happens up to 4-5 lines after the issue happens. You can judge this by the date and time reported in the log lines. 

**Redact/change personally identifiable information** such as your IP address and, possibly, your username or file names.

```

```
