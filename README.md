# Potted CI

This is a "potted" CI chain designed to let you debug and test Jenkins pipelines without the
grind of constantly pushing little revisions to your main source repo, typing up the CI server
for every other user, etc.

It currently contains...

* Jenkins
* SonarQube
  * Plus a PostgreSQL server for SonarQube to store it's reports in - it rapidly moans about using H2

## How to use

* Run `./setup.sh` once to create a local Jenkins home
* run `docker-compose up`
* Watch for the default admin password for Jenkins in the scrollback
* Access 
  * [Jenkins](http://localhost:8090)
  * [SonarQube](http://localhost:9000)

## What it does

It downloads and runs the services. All data storage is mounted in volumes or the local filesystem,
so when you upgrade or change the versions of the container images, it doesn't lose all your jobs
and config, etc. (so long as you use `docker-compose stop`)

## What it doesn't do (unless you want to change that..) 

This stack doesn't do the initial config of Jenkins + SonarQube, including installing plugins,
integrating them, creating webhooks, setting the admin password, etc, etc. You'll have to do that
for yourself. 

*Watch for the initial admin password for Jenkins in the console scrollback.*

## Conveniences

* Your SSH Agent is mounted in the container, so any ssh access that Jenkins demands (like git pulls)
  should Just Work™ (or prompt you for a passphrase on your workstation)
* Your Docker socket is mounted in the container, and the Docker tools are installed, so
  Jenkins can do anything you can do with Docker - where your build stack is all dockerized, 
  this is great. But bear this in mind when deciding what to run.
* Your Docker bridge is made available as a hostname inside the stack - this lets you define repo
  links using `bridge` as a name and Jenkins will pull from your workstation, so long as you have
  `sshd` running. This lets you commit lots of piddly revisions to your local repo without pushing
  them, then rebase them all later and look like you made a fantastic pipeline script all in one go

## Gotchas

I did all this on a Linux machine, so things may differ slightly on OSX.

Folder permissions :

`jenkins` runs as user 1000 in the container ; OSX typically runs users in the 500 range.

I've chosen to mount the Jenkins workspace in my home folder so I can examine it. This is also
helpful for diagnosing issues where e.g. your *real* Jenkins box is running as a different
UID (e.g. 1002) to the common UIDs used inside certain containers (e.g. NodeJS uses 1000) -
so long as you can change your local folder ownership you can simulate these issues (you
may have to insert a line in `Dockerfile-jenkins` to change the UID of the `jenkins` user.
