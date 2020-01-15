#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

function exportNewOrgDefaults() {

  #################################################
  ############### NEW ORG DEFAULTS ################
  #################################################
	
  # default new org name
  export NEW_ORG_NAME=Org3
  
  # default new org name (lowercase)
  export NEW_ORG_LOWERCASE_NAME="${NEW_ORG_NAME,,}"
  
  # default new org MSP name
  export NEW_ORG_MSP_NAME=Org3MSP
  
  # default new org domain
  export NEW_ORG_DOMAIN=org3.example.com
  
  # default port for peer0 of new org
  export PEER0_NEW_ORG_PORT=11051
  
  # default chaincode port for peer0 of new org
  export PEER0_NEW_ORG_CC_PORT=11052
  
  # default port for peer1 of new org
  export PEER1_NEW_ORG_PORT=12051
  
  # default chaincode port for peer1 of new org
  export PEER1_NEW_ORG_CC_PORT=12052
  
  # default port for couchdb4
  export CDB4_PORT=9984
  
  # default port for couchdb5
  export CDB5_PORT=10984
  
  # define default docker compose files for new org
  export COMPOSE_FILE_NEW_ORG=docker-compose-"${NEW_ORG_LOWERCASE_NAME}".yaml
  export COMPOSE_FILE_COUCH_NEW_ORG=docker-compose-couch-"${NEW_ORG_LOWERCASE_NAME}".yaml
}