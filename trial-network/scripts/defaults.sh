#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# add binaries directory to collection of $PATH directories
# export configtx.yaml path to FABRIC_CFG_PATH so the script knows where to find it
# disable verbose logging level
function exportDefaults() {

  #################################################
  ################ SCRIPT DEFAULTS ################
  #################################################

  # prepending $PWD/../bin to PATH to ensure we are picking up the correct binaries
  # this may be commented out to resolve installed version of tools if desired
  export PATH=${PWD}/../bin:${PWD}:$PATH

  # export configtx.yaml path to FABRIC_CFG_PATH so the script knows where to find it
  export FABRIC_CFG_PATH=${PWD}

  # disable verbose logging level
  export VERBOSE=false

  # default language for chaincode
  export LANGUAGE=node
  
  #################################################
  ############### NETWORK DEFAULTS ################
  #################################################

  # default network name
  export NETWORK_NAME=test
  
  #################################################
  ############### ORDERER DEFAULTS ################
  #################################################
  
  # default consensus type
  export CONSENSUS_TYPE=solo

  # default orderer name
  export ORDERER_NAME=Orderer

  # default orderer name (lowercase)
  export ORDERER_LOWERCASE_NAME="${ORDERER_NAME,,}"

  # default orderer domain
  export ORDERER_DOMAIN=example.com

  # default orderer MSP name and ID
  export ORDERER_MSP_NAME="$ORDERER_NAME"MSP
  
  # default port for orderer
  export ORDERER_PORT=7050

  # default port for raft orderer 2
  export RAFT2_PORT=8050

  # default port for raft orderer 3
  export RAFT3_PORT=9050

  # default port for raft orderer 4
  export RAFT4_PORT=10050

  # default port for raft orderer 5
  export RAFT5_PORT=11050

  # default port for kafka orderer
  export KAFKA_ORDERER_PORT=9092

  # default port for kafka zookeper client
  export KZCL_PORT=32181

  # default port for kafka zookeper connect
  export KZCO_PORT=2181

  #################################################
  ################# ORG1 DEFAULTS #################
  #################################################
 
  # default org1 name
  export ORG1_NAME=Org1

  # default org1 name (lowercase)
  export ORG1_LOWERCASE_NAME="${ORG1_NAME,,}"

  # default org1 domain
  export ORG1_DOMAIN="$ORG1_LOWERCASE_NAME".example.com

  # default org1 MSP name and ID
  export ORG1_MSP_NAME="$ORG1_NAME"MSP

  # default port for peer0 of org1
  export PEER0_ORG1_PORT=7051

  # default chaincode port for peer0 of org1
  export PEER0_ORG1_CC_PORT=7052

  # default port for peer1 of org1
  export PEER1_ORG1_PORT=8051

  # default chaincode port for peer1 of org1
  export PEER1_ORG1_CC_PORT=8052
  
  # default port for org1 CA
  export CA_ORG1_PORT=7054

  #################################################
  ################# ORG2 DEFAULTS #################
  #################################################

  # default org2 name
  export ORG2_NAME=Org2	

  # default org2 name (lowercase)
  export ORG2_LOWERCASE_NAME="${ORG2_NAME,,}"

  # default org2 domain
  export ORG2_DOMAIN="$ORG2_LOWERCASE_NAME".example.com

  # default org2 MSP name and ID
  export ORG2_MSP_NAME="$ORG2_NAME"MSP

  # default port for peer0 of org2
  export PEER0_ORG2_PORT=9051

  # default chaincode port for peer0 of org2
  export PEER0_ORG2_CC_PORT=9052

  # default port for peer1 of org2
  export PEER1_ORG2_PORT=10051

  # default chaincode port for peer1 of org2
  export PEER1_ORG2_CC_PORT=10052

  # default port for org2 CA
  export CA_ORG2_PORT=8054

  #################################################
  ############### CHANNEL DEFAULTS ################
  #################################################

  # default consortium name
  export CONSORTIUM_NAME="MyConsortium"

  # default channel name
  export CHANNEL_NAME="mychannel"

  # default main port for couchdb
  export CDB_MAIN_PORT=5984

  #################################################
  ############### COUCHDB DEFAULTS ################
  #################################################
  
  # default port for couchdb1
  export CDB1_PORT=6984
 
  # default port for couchdb2
  export CDB2_PORT=7984
  
  # default port for couchdb3
  export CDB3_PORT=8984
  
}

# Obtain the OS and Architecture string that will be used to select the correct
# native binaries for your platform, e.g., darwin-amd64 or linux-amd64
OS_ARCH=$(echo "$(uname -s | tr '[:upper:]' '[:lower:]' | sed 's/mingw64_nt.*/windows/')-$(uname -m | sed 's/x86_64/amd64/g')" | awk '{print tolower($0)}')

# timeout duration - the duration the CLI should wait for a response from
# another container before giving up
CLI_TIMEOUT=10

# default for delay between commands
CLI_DELAY=3

# system channel name defaults to "sys-channel"
SYS_CHANNEL="sys-channel"

# ca launch set to true by default
CERTIFICATE_AUTHORITIES=true

# use this as the default docker-compose yaml definition
COMPOSE_FILE=docker-compose-cli.yaml

# couchdb compose file
COMPOSE_FILE_COUCH=docker-compose-couch.yaml

# kafka and zookeeper compose file
COMPOSE_FILE_KAFKA=docker-compose-kafka.yaml

# two additional etcd/raft orderers
COMPOSE_FILE_RAFT2=docker-compose-etcdraft2.yaml

# certificate authorities compose file
COMPOSE_FILE_CA=docker-compose-ca.yaml

# default image tag
IMAGETAG="latest"