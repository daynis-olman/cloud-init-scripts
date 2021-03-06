#!/bin/bash

##############################################################################
# USER CONFIGURATION
##############################################################################
EFS_FILE_SYSTEM_ID="fs-XXXXXXXX"
EFS_MOUNT_POINT="/mnt/efs"

# Make sure nfs-utils is installed already (CentOS / Amazon Linux / RHEL)
yum -y install nfs-utils

# Discover environment
INSTANCE_AZ="$(curl http://169.254.169.254/latest/meta-data/placement/availability-zone)"
INSTANCE_REGION="${INSTANCE_AZ:0:-1}"
EFS_DNS="${INSTANCE_AZ}.${EFS_FILE_SYSTEM_ID}.efs.${INSTANCE_REGION}.amazonaws.com"

# Determine if already in fstab before proceeding
if grep -Fq "${EFS_DNS}" /etc/fstab
then
	echo "Mount already exists"
else
	# Mount point must exist before mounting
	mkdir -p ${EFS_MOUNT_POINT}
	# Add to fstab
	echo "${EFS_DNS}:/ ${EFS_MOUNT_POINT} nfs nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 0 0" >> /etc/fstab
	# Mount new file system
	mount ${EFS_MOUNT_POINT}
fi
