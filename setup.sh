#!/usr/bin/env bash

export $(grep -v '^#' .env | xargs)
JENKINS_HOME="${JENKINS_HOME/#\~/$HOME}"

mkdir -p ${JENKINS_HOME}

unset $(grep -v '^#' .env | sed -E 's/(.*)=.*/\1/' | xargs)