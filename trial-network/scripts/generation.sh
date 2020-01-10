#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# Fill certs templates (crypto-config and configtx) with default values
function fillBaseTemplates() {

  echo
  echo "=== Filling templates (crypto-config and configtx) with default values ==="
  echo

  # sed on MacOSX does not support -i flag with a null extension. We will use
  # 't' for our back-up's extension and delete it at the end of the function
  ARCH=$(uname -s | grep Darwin)
  if [ "$ARCH" == "Darwin" ]; then
    OPTS="-it"
  else
    OPTS="-i"
  fi

  # Copy the template to the file that will be modified
  cp crypto-config-template.yaml crypto-config.yaml
  cp configtx-template.yaml configtx.yaml
  
  # Replace strings with default values
  sed $OPTS "s/ORDERER_NAME/${ORDERER_NAME}/g" crypto-config.yaml 
  sed $OPTS "s/ORDERER_LOWERCASE_NAME/${ORDERER_LOWERCASE_NAME}/g" crypto-config.yaml configtx.yaml
  sed $OPTS "s/ORDERER_DOMAIN/${ORDERER_DOMAIN}/g" crypto-config.yaml configtx.yaml
  sed $OPTS "s/ORG1_NAME/${ORG1_NAME}/g" crypto-config.yaml 
  sed $OPTS "s/ORG1_DOMAIN/${ORG1_DOMAIN}/g" crypto-config.yaml configtx.yaml
  sed $OPTS "s/ORG2_NAME/${ORG2_NAME}/g" crypto-config.yaml 
  sed $OPTS "s/ORG2_DOMAIN/${ORG2_DOMAIN}/g" crypto-config.yaml configtx.yaml
  sed $OPTS "s/ORDERER_MSP_NAME/${ORDERER_MSP_NAME}/g" configtx.yaml
  sed $OPTS "s/ORG1_MSP_NAME/${ORG1_MSP_NAME}/g" configtx.yaml
  sed $OPTS "s/ORG2_MSP_NAME/${ORG2_MSP_NAME}/g" configtx.yaml
  sed $OPTS "s/ORDERER_PORT/${ORDERER_PORT}/g" configtx.yaml
  sed $OPTS "s/KAFKA_ORDERER_PORT/${KAFKA_ORDERER_PORT}/g" configtx.yaml
  sed $OPTS "s/PEER0_ORG1_PORT/${PEER0_ORG1_PORT}/g" configtx.yaml
  sed $OPTS "s/PEER0_ORG2_PORT/${PEER0_ORG2_PORT}/g" configtx.yaml
  sed $OPTS "s/CONSORTIUM_NAME/${CONSORTIUM_NAME}/g" configtx.yaml
  
  # If MacOSX, remove temporary backups
  if [ "$ARCH" == "Darwin" ]; then
    rm crypto-config.yaml
    rm configtx.yaml
  fi
}

# Fill docker base templates with default values
function fillDockerBaseTemplates() {

  echo "=== Filling docker base templates with default values ==="
  echo

  # sed on MacOSX does not support -i flag with a null extension. We will use
  # 't' for our back-up's extension and delete it at the end of the function
  ARCH=$(uname -s | grep Darwin)
  if [ "$ARCH" == "Darwin" ]; then
    OPTS="-it"
  else
    OPTS="-i"
  fi

  CURRENT_DIR=$PWD

  cd base

  # Copy the template to the file that will be modified
  cp docker-compose-base-template.yaml docker-compose-base.yaml
  cp peer-base-template.yaml peer-base.yaml
  
  # Replace strings with default values
  sed $OPTS "s/ORDERER_LOWERCASE_NAME/${ORDERER_LOWERCASE_NAME}/g" docker-compose-base.yaml
  sed $OPTS "s/ORDERER_DOMAIN/${ORDERER_DOMAIN}/g" docker-compose-base.yaml
  sed $OPTS "s/ORG1_DOMAIN/${ORG1_DOMAIN}/g" docker-compose-base.yaml
  sed $OPTS "s/ORG2_DOMAIN/${ORG2_DOMAIN}/g" docker-compose-base.yaml
  sed $OPTS "s/ORDERER_MSP_NAME/${ORDERER_MSP_NAME}/g" peer-base.yaml
  sed $OPTS "s/ORG1_MSP_NAME/${ORG1_MSP_NAME}/g" docker-compose-base.yaml
  sed $OPTS "s/ORG2_MSP_NAME/${ORG2_MSP_NAME}/g" docker-compose-base.yaml
  sed $OPTS "s/ORDERER_PORT/${ORDERER_PORT}/g" docker-compose-base.yaml
  sed $OPTS "s/PEER0_ORG1_PORT/${PEER0_ORG1_PORT}/g" docker-compose-base.yaml
  sed $OPTS "s/PEER0_ORG1_CC_PORT/${PEER0_ORG1_CC_PORT}/g" docker-compose-base.yaml
  sed $OPTS "s/PEER1_ORG1_PORT/${PEER1_ORG1_PORT}/g" docker-compose-base.yaml
  sed $OPTS "s/PEER1_ORG1_CC_PORT/${PEER1_ORG1_CC_PORT}/g" docker-compose-base.yaml
  sed $OPTS "s/PEER0_ORG2_PORT/${PEER0_ORG2_PORT}/g" docker-compose-base.yaml
  sed $OPTS "s/PEER0_ORG2_CC_PORT/${PEER0_ORG2_CC_PORT}/g" docker-compose-base.yaml
  sed $OPTS "s/PEER1_ORG2_PORT/${PEER1_ORG2_PORT}/g" docker-compose-base.yaml
  sed $OPTS "s/PEER1_ORG2_CC_PORT/${PEER1_ORG2_CC_PORT}/g" docker-compose-base.yaml
  sed $OPTS "s/NETWORK_NAME/${NETWORK_NAME}/g" peer-base.yaml
  
  # If MacOSX, remove temporary backups
  if [ "$ARCH" == "Darwin" ]; then
    rm docker-compose-base.yaml
    rm peer-base.yaml
  fi

  cd "$CURRENT_DIR"
}

# Fill docker compose templates with default values
function fillDockerComposeTemplates() {

  echo "=== Filling docker compose templates with default values ==="
  echo

  # sed on MacOSX does not support -i flag with a null extension. We will use
  # 't' for our back-up's extension and delete it at the end of the function
  ARCH=$(uname -s | grep Darwin)
  if [ "$ARCH" == "Darwin" ]; then
    OPTS="-it"
  else
    OPTS="-i"
  fi

  # Copy the template to the file that will be modified
  cp docker-compose-cli-template.yaml docker-compose-cli.yaml
  cp docker-compose-couch-template.yaml docker-compose-couch.yaml
  cp docker-compose-etcdraft2-template.yaml docker-compose-etcdraft2.yaml
  cp docker-compose-kafka-template.yaml docker-compose-kafka.yaml
  
  # Replace strings with default values
  sed $OPTS "s/ORDERER_LOWERCASE_NAME/${ORDERER_LOWERCASE_NAME}/g" docker-compose-cli.yaml docker-compose-etcdraft2.yaml
  sed $OPTS "s/ORDERER_DOMAIN/${ORDERER_DOMAIN}/g" docker-compose-cli.yaml docker-compose-etcdraft2.yaml docker-compose-kafka.yaml
  sed $OPTS "s/ORG1_MSP_NAME/${ORG1_MSP_NAME}/g" docker-compose-cli.yaml
  sed $OPTS "s/ORG1_DOMAIN/${ORG1_DOMAIN}/g" docker-compose-cli.yaml docker-compose-couch.yaml
  sed $OPTS "s/ORG2_DOMAIN/${ORG2_DOMAIN}/g" docker-compose-cli.yaml docker-compose-couch.yaml
  sed $OPTS "s/PEER0_ORG1_PORT/${PEER0_ORG1_PORT}/g" docker-compose-cli.yaml
  sed $OPTS "s/ORDERER_PORT/${ORDERER_PORT}/g" docker-compose-etcdraft2.yaml
  sed $OPTS "s/RAFT2_PORT/${RAFT2_PORT}/g" docker-compose-etcdraft2.yaml
  sed $OPTS "s/RAFT3_PORT/${RAFT3_PORT}/g" docker-compose-etcdraft2.yaml
  sed $OPTS "s/RAFT4_PORT/${RAFT4_PORT}/g" docker-compose-etcdraft2.yaml
  sed $OPTS "s/RAFT5_PORT/${RAFT5_PORT}/g" docker-compose-etcdraft2.yaml
  sed $OPTS "s/CDB_MAIN_PORT/${CDB_MAIN_PORT}/g" docker-compose-couch.yaml
  sed $OPTS "s/CDB1_PORT/${CDB1_PORT}/g" docker-compose-couch.yaml
  sed $OPTS "s/CDB2_PORT/${CDB2_PORT}/g" docker-compose-couch.yaml
  sed $OPTS "s/CDB3_PORT/${CDB3_PORT}/g" docker-compose-couch.yaml
  sed $OPTS "s/KAFKA_ORDERER_PORT/${KAFKA_ORDERER_PORT}/g" docker-compose-kafka.yaml
  sed $OPTS "s/KZCL_PORT/${KZCL_PORT}/g" docker-compose-kafka.yaml
  sed $OPTS "s/KZCO_PORT/${KZCO_PORT}/g" docker-compose-kafka.yaml
  sed $OPTS "s/NETWORK_NAME/${NETWORK_NAME}/g" docker-compose-cli.yaml docker-compose-couch.yaml docker-compose-etcdraft2.yaml docker-compose-kafka.yaml
  
  # If MacOSX, remove temporary backups
  if [ "$ARCH" == "Darwin" ]; then
    rm docker-compose-cli.yaml
    rm docker-compose-couch.yaml
    rm docker-compose-etcdraft2.yaml
    rm docker-compose-kafka.yaml
  fi
}

# Export paths for CA Private Keys so we can use string
function exportCaPrivKeyPath() {

  # default dir for ca1 private key
  export CA1_PRIVATE_KEY=$(cd crypto-config/peerOrganizations/"$ORG1_DOMAIN"/ca && ls *_sk)

  # default dir for ca2 private key
  export CA2_PRIVATE_KEY=$(cd crypto-config/peerOrganizations/"$ORG2_DOMAIN"/ca && ls *_sk)
}

# Using docker-compose-ca-template.yaml, replace constants with private key file names
# generated by the cryptogen tool and output a docker-compose.yaml specific to this configuration
# We also hijack this function to fill the remainder of the template
function replacePrivateKey() {

  # sed on MacOSX does not support -i flag with a null extension. We will use
  # 't' for our back-up's extension and delete it at the end of the function
  ARCH=$(uname -s | grep Darwin)
  if [ "$ARCH" == "Darwin" ]; then
    OPTS="-it"
  else
    OPTS="-i"
  fi

  # Copy the template to the file that will be modified to add the private key
  cp docker-compose-ca-template.yaml docker-compose-ca.yaml

  # The next steps will replace the template's contents with the
  # actual values of the private key file names for the two CAs.
  CURRENT_DIR=$PWD
  cd crypto-config/peerOrganizations/"$ORG1_DOMAIN"/ca/
  PRIV_KEY=$(ls *_sk)
  cd "$CURRENT_DIR"
  sed $OPTS "s/CA1_PRIVATE_KEY/${PRIV_KEY}/g" docker-compose-ca.yaml
  cd crypto-config/peerOrganizations/"$ORG2_DOMAIN"/ca/
  PRIV_KEY=$(ls *_sk)
  cd "$CURRENT_DIR"
  sed $OPTS "s/CA2_PRIVATE_KEY/${PRIV_KEY}/g" docker-compose-ca.yaml

  # Replace strings with default values
  sed $OPTS "s/ORG1_LOWERCASE_NAME/${ORG1_LOWERCASE_NAME}/g" docker-compose-ca.yaml
  sed $OPTS "s/ORG1_DOMAIN/${ORG1_DOMAIN}/g" docker-compose-ca.yaml 
  sed $OPTS "s/ORG2_LOWERCASE_NAME/${ORG2_LOWERCASE_NAME}/g" docker-compose-ca.yaml
  sed $OPTS "s/ORG2_DOMAIN/${ORG2_DOMAIN}/g" docker-compose-ca.yaml
  sed $OPTS "s/CA_ORG1_PORT/${CA_ORG1_PORT}/g" docker-compose-ca.yaml
  sed $OPTS "s/CA_ORG2_PORT/${CA_ORG2_PORT}/g" docker-compose-ca.yaml
  sed $OPTS "s/NETWORK_NAME/${NETWORK_NAME}/g" docker-compose-ca.yaml

  # If MacOSX, remove the temporary backup of the docker-compose file
  if [ "$ARCH" == "Darwin" ]; then
    rm docker-compose-ca.yaml
  fi
}

# We will use the cryptogen tool to generate the cryptographic material (x509 certs)
# for our various network entities.  The certificates are based on a standard PKI
# implementation where validation is achieved by reaching a common trust anchor.
#
# Cryptogen consumes a file - ``crypto-config.yaml`` - that contains the network
# topology and allows us to generate a library of certificates for both the
# Organizations and the components that belong to those Organizations.  Each
# Organization is provisioned a unique root certificate (``ca-cert``), that binds
# specific components (peers and orderers) to that Org.  Transactions and communications
# within Fabric are signed by an entity's private key (``keystore``), and then verified
# by means of a public key (``signcerts``).  You will notice a "count" variable within
# this file.  We use this to specify the number of peers per Organization; in our
# case it's two peers per Org.  The rest of this template is extremely
# self-explanatory.
#
# After we run the tool, the certs will be parked in a folder titled ``crypto-config``.

# Generates Org certs using cryptogen tool
function generateCerts() {

  # fill base templates with default values
  fillBaseTemplates

  # check if cryptogen tool is found in a $PATH directory
  which cryptogen
  if [ "$?" -ne 0 ]; then
    echo "cryptogen tool not found. exiting"
    exit 1
  fi
  echo
  echo "=== Generating certificates using cryptogen tool ==="
  echo

  if [ -d "crypto-config" ]; then
    rm -Rf crypto-config
  fi
  set -x
  cryptogen generate --config=crypto-config.yaml
  res=$?
  set +x
  if [ $res -ne 0 ]; then
    echo "Failed to generate certificates..."
    exit 1
  fi
  echo
  echo "=== Generating CCP files ==="
  echo
  ./scripts/ccp-generate.sh
  
  # This needs to be done because some paths in the msp config.yaml are erroneously written with \ instead of /
  echo "=== Fixing path bug ==="
  echo
  find crypto-config -type f -name "config.yaml" -exec sed -i 's/\\/\//g' {} \;
  
  # export strings for CA_1 and CA_2 key paths
  exportCaPrivKeyPath
}

# The `configtxgen tool is used to create four artifacts: orderer **bootstrap
# block**, fabric **channel configuration transaction**, and two **anchor
# peer transactions** - one for each Peer Org.
#
# The orderer block is the genesis block for the ordering service, and the
# channel transaction file is broadcast to the orderer at channel creation
# time.  The anchor peer transactions, as the name might suggest, specify each
# Org's anchor peer on this channel.
#
# Configtxgen consumes a file - ``configtx.yaml`` - that contains the definitions
# for the sample network. There are three members - one Orderer Org (``OrdererOrg``)
# and two Peer Orgs (``ORG1_NAME`` & ``ORG2_NAME``) each managing and maintaining two peer nodes.
# This file also specifies a consortium - ``MyConsortium`` - consisting of our
# two Peer Orgs.  Pay specific attention to the "Profiles" section at the top of
# this file.  You will notice that we have two unique headers. One for the orderer genesis
# block - ``TwoOrgsOrdererGenesis`` - and one for our channel - ``TwoOrgsChannel``.
# These headers are important, as we will pass them in as arguments when we create
# our artifacts.  This file also contains two additional specifications that are worth
# noting.  Firstly, we specify the anchor peers for each Peer Org
# (``peer0.ORG1_DOMAIN`` & ``peer0.ORG2_DOMAIN``).  Secondly, we point to
# the location of the MSP directory for each member, in turn allowing us to store the
# root certificates for each Org in the orderer genesis block.  This is a critical
# concept. Now any network entity communicating with the ordering service can have
# its digital signature verified.
#
# This function will generate the crypto material and our four configuration
# artifacts, and subsequently output these files into the ``channel-artifacts``
# folder.
#
# If you receive the following warning, it can be safely ignored:
#
# [bccsp] GetDefault -> WARN 001 Before using BCCSP, please call InitFactories(). Falling back to bootBCCSP.
#
# You can ignore the logs regarding intermediate certs, we are not using them in
# this crypto implementation.

# Generate orderer genesis block, channel configuration transaction and
# anchor peer update transactions
function generateChannelArtifacts() {

  which configtxgen
  if [ "$?" -ne 0 ]; then
    echo "configtxgen tool not found. exiting"
    exit 1
  fi

  echo
  echo "=== Generating Orderer Genesis block ==="
  echo
  # Note: For some unknown reason (at least for now) the block file can't be
  # named orderer.genesis.block or the orderer will fail to launch!
  echo "CONSENSUS_TYPE="$CONSENSUS_TYPE
  set -x
  if [ "$CONSENSUS_TYPE" == "solo" ]; then
    configtxgen -configPath . -profile TwoOrgsOrdererGenesis -channelID $SYS_CHANNEL -outputBlock channel-artifacts/genesis.block
  elif [ "$CONSENSUS_TYPE" == "kafka" ]; then
    configtxgen -profile SampleDevModeKafka -channelID $SYS_CHANNEL -outputBlock channel-artifacts/genesis.block
  elif [ "$CONSENSUS_TYPE" == "etcdraft" ]; then
    configtxgen -profile SampleMultiNodeEtcdRaft -channelID $SYS_CHANNEL -outputBlock channel-artifacts/genesis.block
  else
    set +x
    echo "unrecognized CONSESUS_TYPE='$CONSENSUS_TYPE'. exiting"
    exit 1
  fi
  res=$?
  set +x
  if [ $res -ne 0 ]; then
    echo "Failed to generate orderer genesis block..."
    exit 1
  fi
  echo
  echo "=== Generating channel configuration transaction 'channel.tx' ==="
  echo
  set -x
  configtxgen -configPath . -profile TwoOrgsChannel -outputCreateChannelTx channel-artifacts/channel.tx -channelID $CHANNEL_NAME
  res=$?
  set +x
  if [ $res -ne 0 ]; then
    echo "Failed to generate channel configuration transaction..."
    exit 1
  fi

  echo
  echo "=== Generating anchor peer update for $ORG1_MSP_NAME ==="
  echo
  set -x
  configtxgen -configPath . -profile TwoOrgsChannel -outputAnchorPeersUpdate channel-artifacts/"$ORG1_MSP_NAME"anchors.tx -channelID $CHANNEL_NAME -asOrg "$ORG1_MSP_NAME"
  res=$?
  set +x
  if [ $res -ne 0 ]; then
    echo "Failed to generate anchor peer update for $ORG1_MSP_NAME..."
    exit 1
  fi

  echo
  echo "=== Generating anchor peer update for $ORG2_MSP_NAME ==="
  echo
  set -x
  configtxgen -configPath . -profile TwoOrgsChannel -outputAnchorPeersUpdate \
    channel-artifacts/"$ORG2_MSP_NAME"anchors.tx -channelID $CHANNEL_NAME -asOrg "$ORG2_MSP_NAME"
  res=$?
  set +x
  if [ $res -ne 0 ]; then
    echo "Failed to generate anchor peer update for $ORG2_MSP_NAME..."
    exit 1
  fi
  echo
}