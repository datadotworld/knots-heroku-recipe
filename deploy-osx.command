#!/usr/bin/env bash
set -o errexit -o nounset -o xtrace
cd -- "$(dirname "$0")"

# Select a knot to deploy
KNOT_EXPORTS=$(ls -a knots | pcregrep -o1 '(.*).zip')
NUM_ZIPS=$(echo ${KNOT_EXPORTS} | wc -l | tr -d ' ')
if [ ${NUM_ZIPS} -eq 0 ] ; then
  echo "There aren't any ZIP files located in the knots folder"
  exit 1
elif [ ${NUM_ZIPS} -eq 1 ] ; then
  SELECTED_KNOT=${KNOT_EXPORTS}
else
  echo "Which knot do you want to deploy:"
  for knot in ${KNOT_EXPORTS} ; do
    echo "  - ${knot}"
  done
  read SELECTED_KNOT

  if [ -f "knots/${SELECTED_KNOT}.zip" ] ; then
    echo "${SELECTED_KNOT} doesn't exist"
    exit 1
  fi
fi

IMAGE=$(echo ${SELECTED_KNOT} | tr '[:upper:]' '[:lower:]')
docker build -t ${IMAGE} .
docker run -it -v $(pwd)/knots:/app/knots --env KNOT=${SELECTED_KNOT} ${IMAGE}
