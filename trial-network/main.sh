#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# This script will orchestrate a sample end-to-end execution of the Hyperledger
# Fabric network.
#
# The end-to-end verification provisions a sample Fabric network consisting of
# two organizations, each maintaining two peers, and a “solo” ordering service.
#
# This verification makes use of two fundamental tools, which are necessary to
# create a functioning transactional network with digital signature validation
# and access control:
#
# * cryptogen - generates the x509 certificates used to identify and
#   authenticate the various components in the network.
# * configtxgen - generates the requisite configuration artifacts for orderer
#   bootstrap and channel creation.
#
# Each tool consumes a configuration yaml file, within which we specify the topology
# of our network (cryptogen) and the location of our certificates for various
# configuration operations (configtxgen).  Once the tools have been successfully run,
# we are able to launch our network.  More detail on the tools and the structure of
# the network will be provided later in this document.  For now, let's get going...

# import defaults and functions   
. scripts/defaults.sh
. scripts/main-utils.sh
. scripts/network.sh

# add binaries directory to collection of $PATH directories
# export configtx.yaml path to FABRIC_CFG_PATH so the script knows where to find it
# disable verbose logging level
exportPaths

# export strings for CA_1 and CA_2 key paths
exportCaPrivKeyPath

# Parse commandline args to determine mode
if [ "$1" = "-m" ]; then 
  shift
fi
MODE=$1
shift

# Here we assign relevant string to $MODE 
# So that we can use that while logging 
assignModeString

# Here we parse the command line arguments
# And assign them to the relevant variable through $OPTARG
while getopts "h?c:t:d:f:s:l:i:o:anv" opt; do
  case "$opt" in
  h | \?)
	printHelp
	exit 0
	;;
  c)
	CHANNEL_NAME=$OPTARG
	;;
  t)
	CLI_TIMEOUT=$OPTARG
	;;
  d)
	CLI_DELAY=$OPTARG
	;;
  f)
	COMPOSE_FILE=$OPTARG
	;;
  s)
	IF_COUCHDB=$OPTARG
	;;
  l)
	LANGUAGE=$OPTARG
	;;
  i)
	IMAGETAG=$(go env GOARCH)"-"$OPTARG
	;;
  o)
	CONSENSUS_TYPE=$OPTARG
	;;
  a)
	CERTIFICATE_AUTHORITIES=false
	;;
  n)
	NO_CHAINCODE=true
	;;
  v)
	VERBOSE=true
	;;
  esac
done

# Announce what was requested
announceSelection

# ask for confirmation to proceed
askProceed

# Check mode and create network using Docker Compose
if [ "${MODE}" == "up" ]; then
  networkUp
elif [ "${MODE}" == "down" ]; then ## Clear the network
  networkDown
elif [ "${MODE}" == "generate" ]; then ## Generate Artifacts
  generateCerts
  replacePrivateKey
  generateChannelArtifacts
elif [ "${MODE}" == "restart" ]; then ## Restart the network
  networkDown
  networkUp
else
  printHelp
  exit 1
fi