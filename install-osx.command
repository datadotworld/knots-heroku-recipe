#!/usr/bin/env bash
set -o errexit -o nounset -o xtrace
cd -- "$(dirname "$0")"

# error if no .zip, more than 1 .zip, or missing a req (heroku, git)
# if git heroku remote, don't create heroku project

# rm -r knot
unzip *.zip -d knot

# For main Makefile, check whether to run sync or fullSync.
# Afterwards, save state (postgres?)
# use heroku deployer to deploy
# heroku login
# heroku update beta
# heroku plugins:install @heroku-cli/plugin-manifest
# git init
# heroku create --manifest
# git add source
# git commit -m '{timestamp.now}'
# git push heroku master
# save state to postgres add-on
# users just need to add zip file
# for update: they replace zip in root and run update.command
