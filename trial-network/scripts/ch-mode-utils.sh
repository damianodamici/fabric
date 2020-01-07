#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# This is a collection of bash functions used by different scripts

# set CA paths for Orderer, Org1, and Org2
ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/"$ORDERER_DOMAIN"/orderers/"$ORDERER_LOWERCASE_NAME"."$ORDERER_DOMAIN"/msp/tlscacerts/tlsca."$ORDERER_DOMAIN"-cert.pem
PEER0_ORG1_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/"$ORG1_DOMAIN"/peers/peer0."$ORG1_DOMAIN"/tls/ca.crt
PEER0_ORG2_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/"$ORG2_DOMAIN"/peers/peer0."$ORG2_DOMAIN"/tls/ca.crt

# verify the result of the script
verifyResult() {
  if [ $1 -ne 0 ]; then
    echo "!!!!!!!!!!!!!!! "$2" !!!!!!!!!!!!!!!!"
    echo "========= ERROR !!! FAILED to execute script ==========="
    echo
    exit 1
  fi
}

setGlobals() {
  PEER=$1
  ORG=$2
  if [ $ORG -eq 1 ]; then
    CORE_PEER_LOCALMSPID="$ORG1_MSP_NAME"
    CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
    CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/"$ORG1_DOMAIN"/users/Admin@"$ORG1_DOMAIN"/msp
    if [ $PEER -eq 0 ]; then
      CORE_PEER_ADDRESS=peer0."$ORG1_DOMAIN":7051
    else
      CORE_PEER_ADDRESS=peer1."$ORG1_DOMAIN":8051
    fi
	
  elif [ $ORG -eq 2 ]; then
    CORE_PEER_LOCALMSPID="$ORG2_MSP_NAME"
    CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
    CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/"$ORG2_DOMAIN"/users/Admin@"$ORG2_DOMAIN"/msp
    if [ $PEER -eq 0 ]; then
      CORE_PEER_ADDRESS=peer0."$ORG2_DOMAIN":9051
    else
      CORE_PEER_ADDRESS=peer1."$ORG2_DOMAIN":10051
    fi
	
  else
    echo "================== ERROR !!! ORG Unknown =================="
  fi

  if [ "$VERBOSE" == "true" ]; then
    env | grep CORE
  fi
}

createChannel() {
setGlobals 0 1

  if [ -z "$CORE_PEER_TLS_ENABLED" -o "$CORE_PEER_TLS_ENABLED" = "false" ]; then
	set -x
	peer channel create -o "$ORDERER_LOWERCASE_NAME"."$ORDERER_DOMAIN":7050 -c $CHANNEL_NAME -f ./channel-artifacts/channel.tx >&log.txt
	res=$?
	set +x
  else
	set -x
	peer channel create -o "$ORDERER_LOWERCASE_NAME"."$ORDERER_DOMAIN":7050 -c $CHANNEL_NAME -f ./channel-artifacts/channel.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA >&log.txt
	res=$?
	set +x
  fi
  cat log.txt
  verifyResult $res "Channel creation failed"
  echo "===================== Channel '$CHANNEL_NAME' created ===================== "
  echo
}

updateAnchorPeers() {
  PEER=$1
  ORG=$2
  setGlobals $PEER $ORG

  if [ -z "$CORE_PEER_TLS_ENABLED" -o "$CORE_PEER_TLS_ENABLED" = "false" ]; then
    set -x
    peer channel update -o "$ORDERER_LOWERCASE_NAME"."$ORDERER_DOMAIN":7050 -c $CHANNEL_NAME -f ./channel-artifacts/${CORE_PEER_LOCALMSPID}anchors.tx >&log.txt
    res=$?
    set +x
  else
    set -x
    peer channel update -o "$ORDERER_LOWERCASE_NAME"."$ORDERER_DOMAIN":7050 -c $CHANNEL_NAME -f ./channel-artifacts/${CORE_PEER_LOCALMSPID}anchors.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA >&log.txt
    res=$?
    set +x
  fi
  cat log.txt
  verifyResult $res "Anchor peer update failed"
  echo "===================== Anchor peers updated for '$CORE_PEER_LOCALMSPID' on channel '$CHANNEL_NAME' ===================== "
  sleep $DELAY
  echo
}

## Sometimes Join takes time hence RETRY at least 5 times
joinChannelWithRetry() {
  PEER=$1
  ORG=$2
  setGlobals $PEER $ORG

  set -x
  peer channel join -b $CHANNEL_NAME.block >&log.txt
  res=$?
  set +x
  cat log.txt
  if [ $res -ne 0 -a $COUNTER -lt $MAX_RETRY ]; then
    COUNTER=$(expr $COUNTER + 1)
    echo "peer${PEER} failed to join the channel, Retry after $DELAY seconds"
    sleep $DELAY
    joinChannelWithRetry $PEER $ORG
  else
    COUNTER=1
  fi
  verifyResult $res "After $MAX_RETRY attempts, peer${PEER} has failed to join channel '$CHANNEL_NAME' "
}

joinChannel () {
  for ORG in 1 2; do
	for PEER in 0 1; do
	joinChannelWithRetry $PEER $ORG
	echo "===================== peer${peer} joined channel '$CHANNEL_NAME' ===================== "
	sleep $DELAY
	echo
	done
  done
}