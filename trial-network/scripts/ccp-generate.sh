#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${P0PORT}/$1/" \
        -e "s/\${P1PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        ccp-template.json 
}

function yaml_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${P0PORT}/$1/" \
        -e "s/\${P1PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        ccp-template.yaml | sed -e $'s/\\\\n/\\\n        /g'
}

P0PORT="$PEER0_ORG1_PORT"
P1PORT="$PEER1_ORG1_PORT"
CAPORT="$CA_ORG1_PORT"
PEERPEM=crypto-config/peerOrganizations/"$ORG1_DOMAIN"/tlsca/tlsca."$ORG1_DOMAIN"-cert.pem
CAPEM=crypto-config/peerOrganizations/"$ORG1_DOMAIN"/ca/ca."$ORG1_DOMAIN"-cert.pem

echo "$(json_ccp $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM)" > connection-org1.json
echo "$(yaml_ccp $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM)" > connection-org1.yaml

sed -i "s/ORG_NAME/${ORG1_NAME}/g" connection-org1.json connection-org1.yaml
sed -i "s/ORG_DOMAIN/${ORG1_DOMAIN}/g" connection-org1.json connection-org1.yaml
sed -i "s/ORG_MSP_NAME/${ORG1_MSP_NAME}/g" connection-org1.json connection-org1.yaml
sed -i "s/ORG_LOWERCASE_NAME/${ORG1_LOWERCASE_NAME}/g" connection-org1.json connection-org1.yaml


P0PORT="$PEER0_ORG2_PORT"
P1PORT="$PEER1_ORG2_PORT"
CAPORT="$CA_ORG2_PORT"
PEERPEM=crypto-config/peerOrganizations/"$ORG2_DOMAIN"/tlsca/tlsca."$ORG2_DOMAIN"-cert.pem
CAPEM=crypto-config/peerOrganizations/"$ORG2_DOMAIN"/ca/ca."$ORG2_DOMAIN"-cert.pem

echo "$(json_ccp $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM)" > connection-org2.json
echo "$(yaml_ccp $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM)" > connection-org2.yaml

sed -i "s/ORG_NAME/${ORG2_NAME}/g" connection-org2.json connection-org2.yaml
sed -i "s/ORG_DOMAIN/${ORG2_DOMAIN}/g" connection-org2.json connection-org2.yaml
sed -i "s/ORG_MSP_NAME/${ORG2_MSP_NAME}/g" connection-org2.json connection-org2.yaml
sed -i "s/ORG_LOWERCASE_NAME/${ORG2_LOWERCASE_NAME}/g" connection-org2.json connection-org2.yaml
