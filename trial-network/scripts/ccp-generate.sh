#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $5)
    local CP=$(one_line_pem $6)
    sed -e "s/\${ORG_NUM}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${P1PORT}/$3/" \
        -e "s/\${CAPORT}/$4/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        ccp-template.json 
}

function yaml_ccp {
    local PP=$(one_line_pem $5)
    local CP=$(one_line_pem $6)
    sed -e "s/\${ORG_NUM}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${P1PORT}/$3/" \
        -e "s/\${CAPORT}/$4/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        ccp-template.yaml | sed -e $'s/\\\\n/\\\n        /g'
}

ORG_NUM=1
P0PORT=7051
P1PORT=8051
CAPORT=7054
PEERPEM=crypto-config/peerOrganizations/"$ORG1_DOMAIN"/tlsca/tlsca."$ORG1_DOMAIN"-cert.pem
CAPEM=crypto-config/peerOrganizations/"$ORG1_DOMAIN"/ca/ca."$ORG1_DOMAIN"-cert.pem

echo "$(json_ccp $ORG_NUM $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM)" > connection-org1.json
echo "$(yaml_ccp $ORG_NUM $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM)" > connection-org1.yaml

sed -i "s/ORG_NAME/${ORG1_NAME}/g" connection-org1.json connection-org1.yaml
sed -i "s/ORG_DOMAIN/${ORG1_DOMAIN}/g" connection-org1.json connection-org1.yaml
sed -i "s/ORG_MSP_NAME/${ORG1_MSP_NAME}/g" connection-org1.json connection-org1.yaml


ORG_NUM=2
P0PORT=9051
P1PORT=10051
CAPORT=8054
PEERPEM=crypto-config/peerOrganizations/"$ORG2_DOMAIN"/tlsca/tlsca."$ORG2_DOMAIN"-cert.pem
CAPEM=crypto-config/peerOrganizations/"$ORG2_DOMAIN"/ca/ca."$ORG2_DOMAIN"-cert.pem

echo "$(json_ccp $ORG_NUM $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM)" > connection-org2.json
echo "$(yaml_ccp $ORG_NUM $P0PORT $P1PORT $CAPORT $PEERPEM $CAPEM)" > connection-org2.yaml

sed -i "s/ORG_NAME/${ORG2_NAME}/g" connection-org2.json connection-org2.yaml
sed -i "s/ORG_DOMAIN/${ORG2_DOMAIN}/g" connection-org2.json connection-org2.yaml
sed -i "s/ORG_MSP_NAME/${ORG2_MSP_NAME}/g" connection-org2.json connection-org2.yaml
