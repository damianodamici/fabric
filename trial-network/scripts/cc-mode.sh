#!/bin/bash

# recover input
CHANNEL_NAME="${1}"
ORDERER_LOWERCASE_NAME="${2}"
ORDERER_DOMAIN="${3}"
ORG1_NAME="${4}"
ORG1_DOMAIN="${5}"
ORG2_NAME="${6}"
ORG2_DOMAIN="${7}"
ORG1_MSP_NAME="${8}"
ORG2_MSP_NAME="${9}"
PEER0_ORG1_PORT="${10}"
PEER1_ORG1_PORT="${11}"
PEER0_ORG2_PORT="${12}"
PEER1_ORG2_PORT="${13}"
ORDERER_PORT="${14}"
LANGUAGE="${15}"

# Echo language
LANGUAGE=`echo "$LANGUAGE" | tr [:upper:] [:lower:]`

# Set chaincode path according to language
# Together with language selection this will be disabled when we finally change the chaincode and select a "final" language
CC_SRC_PATH="github.com/chaincode/chaincode_example02/go/"
if [ "$LANGUAGE" = "node" ]; then
	CC_SRC_PATH="/opt/gopath/src/github.com/chaincode/chaincode_example02/node/"
fi
if [ "$LANGUAGE" = "java" ]; then
	CC_SRC_PATH="/opt/gopath/src/github.com/chaincode/chaincode_example02/java/"
fi

# Defaults 
: ${DELAY:="3"}
: ${VERBOSE:="false"}
: ${TIMEOUT:="10"}

COUNTER=1
MAX_RETRY=10

# import utils
. scripts/ch-mode-utils.sh
. scripts/cc-mode-utils.sh

## Install chaincode on peer0 for the two orgs
setGlobals 0 1
echo
echo "=== Installing chaincode on peer${PEER} of ${ORG_NAME} ==="
echo
installChaincode 0 1

setGlobals 0 2
echo "=== Installing chaincode on peer${PEER} of ${ORG_NAME} ==="
echo
installChaincode 0 2

## Install chaincode on peer1 for the two orgs
setGlobals 1 1
echo "=== Installing chaincode on peer${PEER} of ${ORG_NAME} ==="
echo
installChaincode 1 1

setGlobals 1 2
echo "=== Installing chaincode on peer${PEER} of ${ORG_NAME} ==="
echo
installChaincode 1 2

# Instantiate chaincode on peer0 for the first org1
# Remember that chaincode needs to be instantiated only in one peer
setGlobals 0 2
echo "=== Instantiating chaincode on peer${PEER} of ${ORG_NAME} ==="
echo
instantiateChaincode 0 2

# Query chaincode on peer0.org1
setGlobals 0 1
echo "=== Querying chaincode on peer${PEER} of ${ORG_NAME} ==="
chaincodeQuery 0 1 100

# Invoke chaincode on peer0.org1 and peer0.org2
echo
echo "=== Sending invoke transaction between the peer0 of the two orgs ==="
chaincodeInvoke 0 1 0 2

# Query on chaincode on peer1.org2, check if the result is 90
setGlobals 1 2
echo
echo "=== Querying chaincode on peer${PEER} of ${ORG_NAME} ==="
chaincodeQuery 1 2 90
	
exit 0
