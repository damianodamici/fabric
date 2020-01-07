#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# import functions  
. scripts/generation.sh

# Generate the needed certificates, the genesis block and start the network.
function networkUp() {
  
  # generate artifacts if they don't exist
  if [ ! -d "crypto-config" ]; then
    generateCerts
    replacePrivateKey
    generateChannelArtifacts 
  # export strings for CA_1 and CA_2 key paths
  else exportCaPrivKeyPath
  fi

  # Fill docker base templates with default values
  fillDockerBaseTemplates

  # Fill docker compose templates with default values
  fillDockerComposeTemplates
  
  # here we set all the docker compose files we need to feed the command to have our settings in place
  COMPOSE_FILES="-f ${COMPOSE_FILE}"
  if [ "${CERTIFICATE_AUTHORITIES}" == "true" ]; then
    COMPOSE_FILES="${COMPOSE_FILES} -f ${COMPOSE_FILE_CA}"
  fi
  if [ "${CONSENSUS_TYPE}" == "kafka" ]; then
    COMPOSE_FILES="${COMPOSE_FILES} -f ${COMPOSE_FILE_KAFKA}"
  elif [ "${CONSENSUS_TYPE}" == "etcdraft" ]; then
    COMPOSE_FILES="${COMPOSE_FILES} -f ${COMPOSE_FILE_RAFT2}"
  fi
  if [ "${IF_COUCHDB}" == "couchdb" ]; then
    COMPOSE_FILES="${COMPOSE_FILES} -f ${COMPOSE_FILE_COUCH}"
  fi
  IMAGE_TAG=$IMAGETAG docker-compose ${COMPOSE_FILES} up -d 2>&1
  docker ps -a
  if [ $? -ne 0 ]; then
    echo "ERROR !!!! Unable to start network"
    exit 1
  fi

  if [ "$CONSENSUS_TYPE" == "kafka" ]; then
    sleep 1
    echo "Sleeping 10s to allow $CONSENSUS_TYPE cluster to complete booting"
    sleep 9
  fi

  if [ "$CONSENSUS_TYPE" == "etcdraft" ]; then
    sleep 1
    echo "Sleeping 15s to allow $CONSENSUS_TYPE cluster to complete booting"
    sleep 14
  fi
}

# Tear down running network
function networkDown() {
  
  # stop org1 and org2 containers
  # stop kafka and zookeeper containers in case we're running with kafka consensus-type
  docker-compose -f $COMPOSE_FILE -f $COMPOSE_FILE_COUCH -f $COMPOSE_FILE_KAFKA -f $COMPOSE_FILE_RAFT2 -f $COMPOSE_FILE_CA down --volumes --remove-orphans

  # Don't remove the generated artifacts -- note, the ledgers are always removed
  if [ "$MODE" != "restart" ]; then
    # Bring down the network, deleting the volumes
    #Delete any ledger backups
    docker run -v $PWD:/tmp/first-network --rm hyperledger/fabric-tools:$IMAGETAG rm -Rf /tmp/first-network/ledgers-backup
    #Cleanup the chaincode containers
    clearContainers
    #Cleanup images
    removeUnwantedImages
    # remove orderer block and other channel configuration transactions and certs
    rm -rf channel-artifacts/*.block channel-artifacts/*.tx crypto-config
    # remove all docker compose files generated from templates
    rm -f docker-compose-ca.yaml docker-compose-ca.yaml docker-compose-cli.yaml docker-compose-couch.yaml docker-compose-etcdraft2.yaml docker-compose-kafka.yaml base/peer-base.yaml base/docker-compose-base.yaml
    # remove base config files generated from templates
	rm -f crypto-config.yaml configtx.yaml
    # remove connection profiles
	rm -f connection-org1.yaml connection-org1.json connection-org2.yaml connection-org2.json
  fi
}