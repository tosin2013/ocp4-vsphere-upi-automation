#!/bin/bash 

function approve_certs(){
    CSR_COUNT=$(oc get csr | grep Pending | wc -l)

    while [ $CSR_COUNT -ne 0 ]
    do
        echo "Approve Certs"
        oc get csr -ojson | jq -r '.items[] | select(.status == {} ) | .metadata.name' | xargs oc adm certificate approve
        CSR_COUNT=$(oc get csr | grep Pending | wc -l)
        sleep 30s
    done
}

function check_worker_nodes(){
    READY_NODES=$(oc get nodes | grep worker | wc -l)
    if [ $READY_NODES -ne 2 ]; then
        approve_certs
    fi
}


approve_certs
READY_NODES=$(oc get nodes | grep worker | wc -l)
while [ $READY_NODES -ne 2 ]
do
    check_worker_nodes
    sleep 60s
    READY_NODES=$(oc get nodes | grep worker | wc -l)
done