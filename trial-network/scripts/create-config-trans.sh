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
ORDERER_MSP_NAME="${6}"
ORDERER_LOWERCASE_NAME="${7}"
ORDERER_DOMAIN="${8}"
ORDERER_PORT="${9}"
NEW_ORG_NAME="${10}"
NEW_ORG_LOWERCASE_NAME="${11}"
NEW_ORG_MSP_NAME="${12}"
ORG1_NAME="${13}"
ORG1_MSP_NAME="${14}"
ORG1_DOMAIN="${15}"
PEER0_ORG1_PORT="${16}"
PEER1_ORG1_PORT="${17}"
ORG2_NAME="${18}"
ORG2_MSP_NAME="${19}"
ORG2_DOMAIN="${20}"
PEER0_ORG2_PORT="${21}"
PEER1_ORG2_PORT="${22}"

: ${DELAY:="3"}
: ${TIMEOUT:="10"}

COUNTER=1
MAX_RETRY=5

# Set OrdererOrg.Admin globals
function setOrdererGlobals() {
  CORE_PEER_LOCALMSPID="${ORDERER_MSP_NAME}"
  CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/"${ORDERER_DOMAIN}"/orderers/"${ORDERER_LOWERCASE_NAME}"."${ORDERER_DOMAIN}"/msp/tlscacerts/tlsca."${ORDERER_DOMAIN}"-cert.pem
  CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/"${ORDERER_DOMAIN}"/users/Admin@"${ORDERER_DOMAIN}"/msp
}

# fetchChannelConfig <channel_id> <output_json>
# Writes the current channel config for a given channel to a JSON file
function fetchChannelConfig() {
  CHANNEL=$1
  OUTPUT=$2

  setOrdererGlobals
  
  echo
  echo "=== Fetching the most recent configuration block for the channel ==="
  echo
  if [ -z "$CORE_PEER_TLS_ENABLED" -o "$CORE_PEER_TLS_ENABLED" = "false" ]; then
    set -x
    peer channel fetch config config_block.pb -o "${ORDERER_LOWERCASE_NAME}"."${ORDERER_DOMAIN}":"${ORDERER_PORT}" -c $CHANNEL --cafile $ORDERER_CA
    set +x
  else
    set -x
    peer channel fetch config config_block.pb -o "${ORDERER_LOWERCASE_NAME}"."${ORDERER_DOMAIN}":"${ORDERER_PORT}" -c $CHANNEL --tls --cafile $ORDERER_CA
    set +x
  fi

  echo
  echo "=== Decoding config block to JSON and isolating config to ${OUTPUT} ==="
  echo
  set -x
  configtxlator proto_decode --input config_block.pb --type common.Block | jq .data.data[0].payload.data.config >"${OUTPUT}"
  set +x
}

# createConfigUpdate <channel_id> <original_config.json> <modified_config.json> <output.pb>
# Takes an original and modified config, and produces the config update tx
# which transitions between the two
function createConfigUpdate() {
  CHANNEL=$1
  ORIGINAL=$2
  MODIFIED=$3
  OUTPUT=$4

  set -x
  configtxlator proto_encode --input "${ORIGINAL}" --type common.Config >original_config.pb
  configtxlator proto_encode --input "${MODIFIED}" --type common.Config >modified_config.pb
  configtxlator compute_update --channel_id "${CHANNEL}" --original original_config.pb --updated modified_config.pb >config_update.pb
  configtxlator proto_decode --input config_update.pb --type common.ConfigUpdate >config_update.json
  echo '{"payload":{"header":{"channel_header":{"channel_id":"'$CHANNEL'", "type":2}},"data":{"config_update":'$(cat config_update.json)'}}}' | jq . >config_update_in_envelope.json
  configtxlator proto_encode --input config_update_in_envelope.json --type common.Envelope >"${OUTPUT}"
  set +x
}

# signConfigtxAsPeerOrg <org> <configtx.pb>
# Set the peerOrg admin of an org and signing the config update
function signConfigtxAsPeerOrg() {
  PEERORG=$1
  TX=$2
  setGlobals 0 $PEERORG
  set -x
  peer channel signconfigtx -f "${TX}"
  set +x
}

# import utils
. scripts/ch-mode-utils.sh

echo "=== Creating config transaction to add ${NEW_ORG_NAME} to network ==="
echo

echo "=== Installing jq ==="
echo
apt-get -y update && apt-get -y install jq

# Fetch the config for the channel, writing it to config.json
fetchChannelConfig ${CHANNEL_NAME} config.json

# Modify the configuration to append the new org
export NEW_ORG_MSP_NAME=$NEW_ORG_MSP_NAME
set -x
jq -s '.[0] * {"channel_group":{"groups":{"Application":{"groups": {"NEW_ORG_MSP_NAME":.[1]}}}}}' config.json ./channel-artifacts/"${NEW_ORG_LOWERCASE_NAME}".json > modified_config.json
sed -i "s/NEW_ORG_MSP_NAME/${NEW_ORG_MSP_NAME}/g" modified_config.json
set +x

# Compute a config update, based on the differences between config.json and modified_config.json, write it as a transaction to neworg_update_in_envelope.pb
createConfigUpdate ${CHANNEL_NAME} config.json modified_config.json new_org_update_in_envelope.pb

echo
echo
echo "=== Config transaction to add ${NEW_ORG_NAME} to network created ==="
echo

echo "=== Signing config transaction ==="
echo
signConfigtxAsPeerOrg 1 new_org_update_in_envelope.pb

echo
echo "=== Submitting transaction from a different peer which also signs it ==="
echo
setGlobals 0 2
set -x
peer channel update -f new_org_update_in_envelope.pb -c ${CHANNEL_NAME} -o "${ORDERER_LOWERCASE_NAME}"."${ORDERER_DOMAIN}":"${ORDERER_PORT}" --tls --cafile ${ORDERER_CA}
set +x

echo "=== Config transaction to add ${NEW_ORG_NAME} to network submitted! ==="

exit 0
