#!/usr/bin/env bash
set -o errexit -o nounset -o xtrace
cd -- "$(dirname "$0")"

timestamp=$(date +%s)

heroku login

# The new heroku.yml manifest is still in beta and so we must switch to Heroku beta
heroku update beta
heroku plugins:install @heroku-cli/plugin-manifest

# Extract the knot folder
unzip "knots/${KNOT}.zip" -d knot

# Commit the latest content
if [ -d "knots/.git_${KNOT}" ] ; then
  cp -r "knots/.git_${KNOT}" .git
fi

git init
git add -f knot Dockerfile Makefile heroku.yml requirements.txt
git config user.name 'data.world'
git config user.email 'help@data.world'
git commit -m "${timestamp}"

# Create a new Heroku app if one doesn't exist yet, otherwise, perform an update
if ! heroku info ; then
  heroku create --manifest
fi
APPNAME=$(git remote get-url heroku | pcregrep -o1 '^https://.*/(.*).git$')

# Push the contents
git push heroku master
cp -r .git "knots/.git_${KNOT}"

echo "https://dashboard.heroku.com/apps/${APPNAME}"
