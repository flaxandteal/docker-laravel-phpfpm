#!/bin/bash

mkdir -p ~/.ssh
cat /deploy/idrsa > ~/.ssh/deploy
cat /deploy/idrsa.pub > ~/.ssh/deploy.pub
chmod 600 ~/.ssh/deploy
cat <<ENDSSHCONFIG > ~/.ssh/config
Host gitlab
  HostName gitlab.com
  User git
  StrictHostKeyChecking no
  IdentityFile ~/.ssh/deploy
ENDSSHCONFIG

git clone gitlab:$GITLAB_REPOSITORY /data/www
chown -R www-data /data/www/storage

exec /usr/sbin/php5-fpm -F
