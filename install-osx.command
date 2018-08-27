#!/usr/bin/env bash
set -o errexit -o nounset -o xtrace
cd -- "$(dirname "$0")"

timestamp=$(date +%s)

# Check that exactly one zip file has been added to the directory
num_zips=$(ls *.zip 2>/dev/null | wc -l | tr -d ' ')
if [ ${num_zips} -ne 1 ] ; then
  echo "Need exactly 1 zip file, found '${num_zips}'"
  exit 1
fi

# Check that all of the dependencies are installed
dependencies=(git heroku)
for dep in ${dependencies[@]}; do
  if [ ! -x "$(command -v ${dep})" ] ; then
    echo "'${dep}' is not installed or is inaccessible"
    exit 1
  fi
done

# Log in to Heroku if required
if ! heroku whoami ; then
  heroku login
fi

# The new heroku.yml manifest is still in beta and so we must switch to Heroku beta
heroku update beta
heroku plugins:install @heroku-cli/plugin-manifest

# Extract the knot folder
rm -rf knot
unzip *.zip -d knot

# Commit the latest content
git init
git add -f knot Dockerfile Makefile heroku.yml requirements.txt
git commit -m "${timestamp}" || True

# Create a new Heroku app if one doesn't exist yet, otherwise, perform an update
if ! heroku info ; then
  heroku create --manifest
fi
appname=$(git remote get-url heroku | pcregrep -o1 '^https://.*/(.*).git$')

# Push the contents & open the app's Overview page
git push heroku master
open "https://dashboard.heroku.com/apps/${appname}"


# TODO For main Makefile, check whether to run sync or fullSync. Check for existence of latest state

# TODO save state to postgres add-on
