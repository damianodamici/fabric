#!/bin/bash
#
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

CHANNEL_NAME="${1}"
DELAY="${2}"
LANGUAGE="${3}"
TIMEOUT="${4}"
VERBOSE="${5}"
ORDERER_LOWERCASE_NAME="${6}"
ORDERER_DOMAIN="${7}"
ORDERER_PORT="${8}"
NEW_ORG_NAME="${9}"
NEW_ORG_LOWERCASE_NAME="${10}"
NEW_ORG_MSP_NAME="${11}"
NEW_ORG_DOMAIN="${12}"
PEER0_NEW_ORG_PORT="${13}"
PEER1_NEW_ORG_PORT="${14}"

: ${DELAY:="3"}
: ${TIMEOUT:="10"}

COUNTER=1
MAX_RETRY=5

# import utils
. scripts/ch-mode-utils.sh

echo "=== Fetching channel config block from orderer ==="
echo
set -x
peer channel fetch 0 $CHANNEL_NAME.block -o "${ORDERER_LOWERCASE_NAME}"."${ORDERER_DOMAIN}":"${ORDERER_PORT}" -c $CHANNEL_NAME --tls --cafile $ORDERER_CA >&log.txt
res=$?
set +x
cat log.txt
verifyResult $res "Fetching config block from orderer has Failed"

joinChannelWithRetry 0 3
echo
echo "=== peer0 of ${ORG_NAME} joined channel '$CHANNEL_NAME' ==="
echo

joinChannelWithRetry 1 3
echo
echo "=== peer1 of ${ORG_NAME} joined channel '$CHANNEL_NAME' ==="

exit 0
