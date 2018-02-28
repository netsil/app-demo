#!/bin/bash
if [ -z "${NETSIL_SP_HOST}" ] || [ -z "${NETSIL_ORGANIZATION_ID}" ] || [ -z "${NETSIL_COLLECTORS_VERSION}" ]; then
    echo "Error! Did not specify NETSIL_SP_HOST or NETSIL_ORGANIZATION_ID"
else
    sudo docker run -td \
                --name=netsil_collectors \
                --net=host \
                -v /var/run/docker.sock:/var/run/docker.sock:ro \
                -v /proc/:/host/proc/:ro \
                -v /sys/fs/cgroup/:/host/sys/fs/cgroup:ro \
                --cap-add=NET_RAW \
                --cap-add=NET_ADMIN \
                --ulimit core=0 \
                -e DEPLOY_ENV="docker" \
                -e SD_BACKEND="docker" \
                -e SAMPLINGRATE="100" \
                -e TAGS="apptype:mobile,apptier:webservers" \
                -e NETSIL_SP_HOST=${NETSIL_SP_HOST} \
                -e NETSIL_ORGANIZATION_ID=${NETSIL_ORGANIZATION_ID} \
                netsil/collectors:stable-${NETSIL_COLLECTORS_VERSION}
fi
