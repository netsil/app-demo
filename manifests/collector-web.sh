#!/bin/bash
if [ -z "${NETSIL_SP_HOST}" ] || [ -z "${NETSIL_ORGANIZATION_ID}" ] || [ -z "${NETSIL_COLLECTORS_VERSION}" ]; then
    echo "Error! Did not specify NETSIL_SP_HOST or NETSIL_ORGANIZATION_ID"
else
    wget --no-check-certificate --header="userport: 443" \
         -O /usr/bin/install-netsil-collectors.sh https://${NETSIL_SP_HOST}/install_netsil_collectors \
        && chmod +x /usr/bin/install-netsil-collectors.sh \
        && NETSIL_COLLECTORS_VERSION=${NETSIL_COLLECTORS_VERSION} NETSIL_SP_HOST=${NETSIL_SP_HOST} NETSIL_ORGANIZATION_ID=${NETSIL_ORGANIZATION_ID} NETSIL_NICE_VALUE=15 SAMPLINGRATE=100 TAGS="apptype:mobile,apptier:web" /usr/bin/install-netsil-collectors.sh \
        && /etc/init.d/netsil-collectors restart
fi
