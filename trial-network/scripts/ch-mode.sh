#!/bin/bash

# recover input
CHANNEL_NAME="$1"
ORDERER_LOWERCASE_NAME="$2"
ORDERER_DOMAIN="$3"
ORG1_NAME="$4"
ORG1_DOMAIN="$5"
ORG2_NAME="$6"
ORG2_DOMAIN="$7"
ORG1_MSP_NAME="$8"
ORG2_MSP_NAME="$9"

# import utils
. scripts/ch-mode-utils.sh

# Defaults in case of no argument
: ${DELAY:="3"}
: ${VERBOSE:="false"}

COUNTER=1
MAX_RETRY=10

echo
echo "Channel name : '${CHANNEL_NAME}'"
echo

## Create channel
echo "Creating channel..."
echo
createChannel

## Join all the peers to the channel
echo "Having all peers join the channel..."
echo
joinChannel

## Set the anchor peers for each org in the channel
echo "Updating anchor peers for '${ORG1_NAME}'..."
echo
updateAnchorPeers 0 1

echo "Updating anchor peers for '${ORG2_NAME}'..."
echo
updateAnchorPeers 0 2

exit 0