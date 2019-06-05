#!/bin/bash

export RAPIDMINER_HOME=${HOME}/bin/rapidminer-studio
export JAVA_HOME=${HOME}/.sdkman/candidates/java/current

"${HOME}"/bin/rapidminer-studio/RapidMiner-Studio.sh "${@}" &
