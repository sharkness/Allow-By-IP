#!/bin/bash

IP=$(dig @resolver4.opendns.com myip.opendns.com +short)
echo "Adding ${IP} to the allow list"

ENTRY_ID=$(curl --request POST \
            --proxy ${CI_PROXY_SERVER} \
            --url https://api.github.com/graphql \
            --header "Authorization: Bearer ${IP_LIST_TOKEN}" \
            --header 'Content-Type: application/json' \
            --data '{"query":"mutation addIPRange {\n  createIpAllowListEntry(input: \n    {\n      allowListValue: \"'"${IP}"'\", \n      name: \"github build agent\", \n      ownerId: \"'"${OWNID}"'\", \n      isActive: true\n    }) {\n    ipAllowListEntry {\n      id\n      allowListValue\n    }\n  }\n}\n","operationName":"addIPRange"}' \
            | grep "\"id\":" | sed -e "s/^.*id\":\"\(.*\)\",.*/\1/" )
echo "IP Grant Access Script Finished Entry ID: ${ENTRY_ID}"
echo "ENTRY_ID=$ENTRY_ID" >> $GITHUB_ENV

