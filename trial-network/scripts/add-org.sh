#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# Fill connection profile template for new org with default values
function generateNewOrgCcp () {

  # sed on MacOSX does not support -i flag with a null extension. We will use
  # 't' for our back-up's extension and delete it at the end of the function
  ARCH=$(uname -s | grep Darwin)
  if [ "$ARCH" == "Darwin" ]; then
    OPTS="-it"
  else
    OPTS="-i"
  fi
  
  # Copy the template to the file that will be modified
  cp new-org-ccp-template.yaml connection-"${NEW_ORG_LOWERCASE_NAME}".yaml
  cp new-org-ccp-template.json connection-"${NEW_ORG_LOWERCASE_NAME}".json
  
  # Replace strings with default values
  sed $OPTS "s/NEW_ORG_LOWERCASE_NAME/${NEW_ORG_LOWERCASE_NAME}/g" connection-"${NEW_ORG_LOWERCASE_NAME}".yaml connection-"${NEW_ORG_LOWERCASE_NAME}".json
  sed $OPTS "s/NEW_ORG_NAME/${NEW_ORG_NAME}/g" connection-"${NEW_ORG_LOWERCASE_NAME}".yaml connection-"${NEW_ORG_LOWERCASE_NAME}".json
  sed $OPTS "s/NEW_ORG_MSP_NAME/${NEW_ORG_MSP_NAME}/g" connection-"${NEW_ORG_LOWERCASE_NAME}".yaml connection-"${NEW_ORG_LOWERCASE_NAME}".json
  sed $OPTS "s/NEW_ORG_DOMAIN/${NEW_ORG_DOMAIN}/g" connection-"${NEW_ORG_LOWERCASE_NAME}".yaml connection-"${NEW_ORG_LOWERCASE_NAME}".json
  sed $OPTS "s/PEER0_NEW_ORG_PORT/${PEER0_NEW_ORG_PORT}/g" connection-"${NEW_ORG_LOWERCASE_NAME}".yaml connection-"${NEW_ORG_LOWERCASE_NAME}".json
  sed $OPTS "s/PEER1_NEW_ORG_PORT/${PEER1_NEW_ORG_PORT}/g" connection-"${NEW_ORG_LOWERCASE_NAME}".yaml connection-"${NEW_ORG_LOWERCASE_NAME}".json
  
  # If MacOSX, remove temporary backups
  if [ "$ARCH" == "Darwin" ]; then
    rm connection-"${NEW_ORG_LOWERCASE_NAME}".yaml
    rm connection-"${NEW_ORG_LOWERCASE_NAME}".json
  fi
}

# Fill certs templates (crypto-config and configtx) with default values
function fillNewOrgBaseTemplates() {

  echo
  echo "=== Filling templates for ${NEW_ORG_NAME} (crypto-config and configtx) with default values ==="
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

  # Copy the template to the file that will be modified
  cd new-org-artifacts
  cp crypto-config-template.yaml crypto-config.yaml
  cp configtx-template.yaml configtx.yaml
  
  # Replace strings with default values
  sed $OPTS "s/NEW_ORG_NAME/${NEW_ORG_NAME}/g" crypto-config.yaml 
  sed $OPTS "s/NEW_ORG_MSP_NAME/${NEW_ORG_MSP_NAME}/g" configtx.yaml 
  sed $OPTS "s/NEW_ORG_DOMAIN/${NEW_ORG_DOMAIN}/g" configtx.yaml crypto-config.yaml 
  sed $OPTS "s/PEER0_NEW_ORG_PORT/${PEER0_NEW_ORG_PORT}/g" configtx.yaml 
  
  # If MacOSX, remove temporary backups
  if [ "$ARCH" == "Darwin" ]; then
    rm crypto-config.yaml
    rm configtx.yaml
  fi
  
  cd $CURRENT_DIR
}

# Fill docker compose templates with default values
function fillDockerComposeTemplates() {

  echo
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
  cp docker-compose-new-org-template.yaml docker-compose-"${NEW_ORG_LOWERCASE_NAME}".yaml
  cp docker-compose-couch-new-org-template.yaml docker-compose-couch-"${NEW_ORG_LOWERCASE_NAME}".yaml
  
  # Replace strings with default values
  sed $OPTS "s/NEW_ORG_DOMAIN/${NEW_ORG_DOMAIN}/g" docker-compose-"${NEW_ORG_LOWERCASE_NAME}".yaml docker-compose-couch-"${NEW_ORG_LOWERCASE_NAME}".yaml
  sed $OPTS "s/NETWORK_NAME/${NETWORK_NAME}/g" docker-compose-"${NEW_ORG_LOWERCASE_NAME}".yaml docker-compose-couch-"${NEW_ORG_LOWERCASE_NAME}".yaml
  sed $OPTS "s/NEW_ORG_MSP_NAME/${NEW_ORG_MSP_NAME}/g" docker-compose-"${NEW_ORG_LOWERCASE_NAME}".yaml
  sed $OPTS "s/NEW_ORG_NAME/${NEW_ORG_NAME}/g" docker-compose-"${NEW_ORG_LOWERCASE_NAME}".yaml
  sed $OPTS "s/PEER0_NEW_ORG_PORT/${PEER0_NEW_ORG_PORT}/g" docker-compose-"${NEW_ORG_LOWERCASE_NAME}".yaml
  sed $OPTS "s/PEER1_NEW_ORG_PORT/${PEER1_NEW_ORG_PORT}/g" docker-compose-"${NEW_ORG_LOWERCASE_NAME}".yaml
  sed $OPTS "s/PEER0_NEW_ORG_CC_PORT/${PEER0_NEW_ORG_CC_PORT}/g" docker-compose-"${NEW_ORG_LOWERCASE_NAME}".yaml
  sed $OPTS "s/PEER1_NEW_ORG_CC_PORT/${PEER1_NEW_ORG_CC_PORT}/g" docker-compose-"${NEW_ORG_LOWERCASE_NAME}".yaml
  sed $OPTS "s/ORG1_DOMAIN/${ORG1_DOMAIN}/g" docker-compose-"${NEW_ORG_LOWERCASE_NAME}".yaml
  sed $OPTS "s/ORG2_DOMAIN/${ORG2_DOMAIN}/g" docker-compose-"${NEW_ORG_LOWERCASE_NAME}".yaml
  sed $OPTS "s/CDB_MAIN_PORT/${CDB_MAIN_PORT}/g" docker-compose-couch-"${NEW_ORG_LOWERCASE_NAME}".yaml
  sed $OPTS "s/CDB4_PORT/${CDB4_PORT}/g" docker-compose-couch-"${NEW_ORG_LOWERCASE_NAME}".yaml
  sed $OPTS "s/CDB5_PORT/${CDB5_PORT}/g" docker-compose-couch-"${NEW_ORG_LOWERCASE_NAME}".yaml
  
  # If MacOSX, remove temporary backups
  if [ "$ARCH" == "Darwin" ]; then
    rm docker-compose-"${NEW_ORG_LOWERCASE_NAME}".yaml
    rm docker-compose-couch-"${NEW_ORG_LOWERCASE_NAME}".yaml
  fi
}

# We use the cryptogen tool to generate the cryptographic material
# (x509 certs) for the new org.  After we run the tool, the certs will
# be parked in the BYFN folder titled ``crypto-config``.

# Generates Org3 certs using cryptogen tool
function generateCerts (){

  # fill new org templates with default values
  fillNewOrgBaseTemplates
  
  which cryptogen
  if [ "$?" -ne 0 ]; then
    echo "cryptogen tool not found. exiting"
    exit 1
  fi
  
  echo
  echo "=== Generating certificates for ${NEW_ORG_NAME} using cryptogen tool ==="
  echo

  (cd new-org-artifacts
   set -x
   cryptogen generate --config=./crypto-config.yaml
   res=$?
   set +x
   if [ $res -ne 0 ]; then
     echo "Failed to generate certificates for ${NEW_ORG_NAME}..."
     exit 1
   fi
  )
  
  echo
  echo "=== Generating CCP files for ${NEW_ORG_NAME} ==="
  echo
  generateNewOrgCcp
  
  # This needs to be done because some paths in the msp config.yaml are erroneously written with \ instead of /
  echo "=== Fixing path bug ==="
  echo
  find new-org-artifacts/crypto-config -type f -name "config.yaml" -exec sed -i 's/\\/\//g' {} \;
}

# Generate channel configuration transaction
function generateChannelArtifacts() {

  which configtxgen
  if [ "$?" -ne 0 ]; then
    echo "configtxgen tool not found. exiting"
    exit 1
  fi
  
  echo
  echo "=== Generating ${NEW_ORG_NAME} config material ==="
  echo
  
  (cd new-org-artifacts
   export FABRIC_CFG_PATH=$PWD
   set -x
   configtxgen -printOrg "$NEW_ORG_MSP_NAME" > ../channel-artifacts/"$NEW_ORG_LOWERCASE_NAME".json
   res=$?
   set +x
   if [ $res -ne 0 ]; then
     echo "Failed to generate config material for ${NEW_ORG_NAME}..."
     exit 1
   fi
  )
  cp -r crypto-config/ordererOrganizations new-org-artifacts/crypto-config/
  echo
}

# Use the CLI container to create the configuration transaction needed to add
# the new org to the network
function createConfigTx () {
  echo "=== Generate and submit config tx to add ${NEW_ORG_NAME} ==="
  echo
  docker exec cli scripts/create-config-trans.sh $CHANNEL_NAME $CLI_DELAY $LANGUAGE $CLI_TIMEOUT $VERBOSE $ORDERER_MSP_NAME $ORDERER_LOWERCASE_NAME $ORDERER_DOMAIN $ORDERER_PORT $NEW_ORG_NAME $NEW_ORG_LOWERCASE_NAME $NEW_ORG_MSP_NAME $ORG1_NAME $ORG1_MSP_NAME $ORG1_DOMAIN $PEER0_ORG1_PORT $PEER1_ORG1_PORT $ORG2_NAME $ORG2_MSP_NAME $ORG2_DOMAIN $PEER0_ORG2_PORT $PEER1_ORG2_PORT
  if [ $? -ne 0 ]; then
    echo "ERROR !!!! Unable to create config tx"
    exit 1
  fi
}

# Generate the needed certificates, the genesis block and add the new org to the network
function newOrgUp () {
  # generate artifacts if they don't exist
  if [ ! -d "new-org-artifacts/crypto-config" ]; then
    generateCerts
    generateChannelArtifacts
    createConfigTx
  fi
  
  fillDockerComposeTemplates
  
  # start new org peers
  if [ "${IF_COUCHDB}" == "couchdb" ]; then
      IMAGE_TAG=${IMAGETAG} docker-compose -f $COMPOSE_FILE_NEW_ORG -f $COMPOSE_FILE_COUCH_NEW_ORG up -d 2>&1
  else
      IMAGE_TAG=$IMAGETAG docker-compose -f $COMPOSE_FILE_NEW_ORG up -d 2>&1
  fi
  if [ $? -ne 0 ]; then
    echo "ERROR !!!! Unable to start ${NEW_ORG_NAME} network"
    exit 1
  fi
  echo
  echo "=== Have ${NEW_ORG_NAME} peers join network ==="
  echo
  docker exec "${NEW_ORG_NAME}"cli ./scripts/new-org-up-and-channel.sh $CHANNEL_NAME $CLI_DELAY $LANGUAGE $CLI_TIMEOUT $VERBOSE $ORDERER_LOWERCASE_NAME $ORDERER_DOMAIN $ORDERER_PORT $NEW_ORG_NAME $NEW_ORG_LOWERCASE_NAME $NEW_ORG_MSP_NAME $NEW_ORG_DOMAIN $PEER0_NEW_ORG_PORT $PEER1_NEW_ORG_PORT
  if [ $? -ne 0 ]; then
    echo "ERROR !!!! Unable to have ${NEW_ORG_NAME} peers join network"
    exit 1
  fi

#  echo
#  echo "###############################################################"
#  echo "##### Upgrade chaincode to have Org3 peers on the network #####"
#  echo "###############################################################"
#  docker exec cli ./scripts/step3org3.sh $CHANNEL_NAME $CLI_DELAY $LANGUAGE $CLI_TIMEOUT $VERBOSE
#  if [ $? -ne 0 ]; then
#    echo "ERROR !!!! Unable to add Org3 peers on network"
#    exit 1
#  fi
#  # finish by running the test
#  docker exec Org3cli ./scripts/testorg3.sh $CHANNEL_NAME $CLI_DELAY $LANGUAGE $CLI_TIMEOUT $VERBOSE
#  if [ $? -ne 0 ]; then
#    echo "ERROR !!!! Unable to run test"
#    exit 1
#  fi
}

# import utils
. scripts/main-utils.sh
. scripts/ch-mode-utils.sh
. scripts/defaults.sh
. scripts/new-org-defaults.sh

# If no pre-existing network generated with main.sh, abort
if [ ! -d crypto-config ]; then
  echo
  echo "ERROR: Please, run main.sh first to generate and deploy the two orgs network."
  echo
  exit 1
fi

# export defaults 
exportNewOrgDefaults

# go ahead and do all steps to add new org
newOrgUp