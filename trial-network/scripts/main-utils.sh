#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# Here we assign relevant string to $MODE 
# So that we can use that while logging 
function assignModeString() {
	if [ "$MODE" == "up" ]; then
	  EXPMODE="Starting"
	elif [ "$MODE" == "down" ]; then
	  EXPMODE="Stopping"
	elif [ "$MODE" == "restart" ]; then
	  EXPMODE="Restarting"
	elif [ "$MODE" == "generate" ]; then
	  EXPMODE="Generating certs and genesis block"
	elif [ "$MODE" == "channel" ]; then
	  EXPMODE="Creating channel, setting anchor peers, and having peers join it"
	elif [ "$MODE" == "chaincode" ]; then
	  EXPMODE="Installing test chaincode, instantiating it, and testing its functioning"
	else
	  printHelp
	  exit 1
	fi
}

function announceSelection() {
	if [ "${IF_COUCHDB}" == "couchdb" ]; then
	  echo
	  echo "${EXPMODE} for channel '${CHANNEL_NAME}' with CLI timeout of '${CLI_TIMEOUT}' seconds and CLI delay of '${CLI_DELAY}' seconds and using database '${IF_COUCHDB}'"
	else
	  echo "${EXPMODE} for channel '${CHANNEL_NAME}' with CLI timeout of '${CLI_TIMEOUT}' seconds and CLI delay of '${CLI_DELAY}' seconds"
	fi
}

# Print the usage message
function printHelp() {
  echo "Usage: "
  echo "  main.sh <mode> [-c <channel name>] [-t <timeout>] [-d <delay>] [-f <docker-compose-file>] [-s <dbtype>] [-l <language>] [-o <consensus-type>] [-i <imagetag>] [-a] [-n] [-v]"
  echo "    <mode> - one of 'up', 'down', 'restart', 'generate', or 'channel'"
  echo "      - 'up' - bring up the network with docker-compose up"
  echo "      - 'down' - clear the network with docker-compose down"
  echo "      - 'restart' - restart the network"
  echo "      - 'generate' - generate required certificates and genesis block"
  echo "      - 'channel' - create channel, set anchor peers, and have peers join it"
  echo "      - 'chaincode' - install test chaincode, instantiate it, and test its functioning"
  echo "    -c <channel name> - channel name to use (defaults to \"mychannel\")"
  echo "    -t <timeout> - CLI timeout duration in seconds (defaults to 10)"
  echo "    -d <delay> - delay duration in seconds (defaults to 3)"
  echo "    -f <docker-compose-file> - specify which docker-compose file use (defaults to docker-compose-cli.yaml)"
  echo "    -s <dbtype> - the database backend to use: goleveldb (default) or couchdb"
  echo "    -l <language> - the chaincode language: golang (default) or node"
  echo "    -o <consensus-type> - the consensus-type of the ordering service: solo (default), kafka, or etcdraft"
  echo "    -i <imagetag> - the tag to be used to launch the network (defaults to \"latest\")"
  echo "    -a - do not launch certificate authorities (launched by default)"
  echo "    -v - verbose mode"
  echo "  main.sh -h (print this message)"
  echo
  echo "Typically, one would first generate the required certificates and "
  echo "genesis block, then bring up the network. e.g.:"
  echo
  echo "	main.sh generate -c mychannel"
  echo "	main.sh up -c mychannel -s couchdb"
  echo "    main.sh up -c mychannel -s couchdb -i 1.4.0"
  echo "	main.sh up -l node"
  echo "	main.sh down -c mychannel"
  echo
  echo "Taking all defaults:"
  echo "	main.sh generate"
  echo "	main.sh up"
  echo "	main.sh down"
}

# Ask user for confirmation to proceed
function askProceed() {
  read -p "Continue? [Y/n] " ans
  case "$ans" in
  y | Y | "")
    echo "proceeding ..."
    ;;
  n | N)
    echo "exiting..."
    exit 1
    ;;
  *)
    echo "invalid response"
    askProceed
    ;;
  esac
}

# Obtain CONTAINER_IDS and remove them
# TODO Might want to make this optional - could clear other containers
function clearContainers() {
  CONTAINER_IDS=$(docker ps -a | awk '($2 ~ /dev-peer.*/) {print $1}')
  if [ -z "$CONTAINER_IDS" -o "$CONTAINER_IDS" == " " ]; then
    echo "---- No containers available for deletion ----"
  else
    docker rm -f $CONTAINER_IDS
  fi
}

# Delete any images that were generated as a part of this setup
# specifically the following images are often left behind:
# TODO list generated image naming patterns
function removeUnwantedImages() {
  DOCKER_IMAGE_IDS=$(docker images | awk '($1 ~ /dev-peer.*/) {print $3}')
  if [ -z "$DOCKER_IMAGE_IDS" -o "$DOCKER_IMAGE_IDS" == " " ]; then
    echo "---- No images available for deletion ----"
  else
    docker rmi -f $DOCKER_IMAGE_IDS
  fi
}