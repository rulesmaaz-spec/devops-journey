# K8s Persistent Volumes

## The Problem
Container storage is ephemeral. If a DB Pod crashes, data is lost.

## The Solution
- **PV**: The actual storage.
- **PVC**: The request for storage.
- **StorageClass**: Dynamic provisioning.

## Lab Proof
I ran a Pod, wrote a file to a mounted PVC, deleted the Pod, and recreated it. The file persisted.
