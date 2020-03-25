export KUBEADMIN=/root/install-dir/auth/kubeconfig

oc project openshift-image-registry

oc patch configs.imageregistry.operator.openshift.io cluster --type merge --patch '{"spec":{"managementState": "Managed"}}'

cat >openshift-image-registiry.yml<<YAML
apiVersion: "v1"
kind: "PersistentVolumeClaim"
metadata:
  name: "image-registry-pvc"
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 100Gi
  storageClassName: nfs-storage-provisioner
  volumeMode: Filesystem
YAML

oc create -f openshift-image-registiry.yml

oc patch configs.imageregistry.operator.openshift.io cluster --type merge --patch '{"spec":{"storage": {"pvc": {"claim": "image-registry-pvc"}}}}'
