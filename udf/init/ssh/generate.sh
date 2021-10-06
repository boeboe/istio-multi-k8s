#!/usr/bin/env bash

TMP_BASE_DIR=/tmp/ssh-udf

echo "Creating temporary output folders"
mkdir -p ${TMP_BASE_DIR}/jumphost
mkdir -p ${TMP_BASE_DIR}/master1
mkdir -p ${TMP_BASE_DIR}/node11
mkdir -p ${TMP_BASE_DIR}/node12
mkdir -p ${TMP_BASE_DIR}/master2
mkdir -p ${TMP_BASE_DIR}/node21
mkdir -p ${TMP_BASE_DIR}/node22
mkdir -p ${TMP_BASE_DIR}/vm1
mkdir -p ${TMP_BASE_DIR}/vm2


echo "Generating ssh key pairs"
ssh-keygen -b 2048 -t rsa -f ${TMP_BASE_DIR}/jumphost/id_rsa -C ubuntu@jumphost -q -N ""
ssh-keygen -b 2048 -t rsa -f ${TMP_BASE_DIR}/master1/id_rsa  -C ubuntu@master1  -q -N ""
ssh-keygen -b 2048 -t rsa -f ${TMP_BASE_DIR}/node11/id_rsa   -C ubuntu@node11   -q -N ""
ssh-keygen -b 2048 -t rsa -f ${TMP_BASE_DIR}/node12/id_rsa   -C ubuntu@node12   -q -N ""
ssh-keygen -b 2048 -t rsa -f ${TMP_BASE_DIR}/master2/id_rsa  -C ubuntu@master2  -q -N ""
ssh-keygen -b 2048 -t rsa -f ${TMP_BASE_DIR}/node21/id_rsa   -C ubuntu@node21   -q -N ""
ssh-keygen -b 2048 -t rsa -f ${TMP_BASE_DIR}/node22/id_rsa   -C ubuntu@node22   -q -N ""
ssh-keygen -b 2048 -t rsa -f ${TMP_BASE_DIR}/vm1/id_rsa      -C ubuntu@vm1      -q -N ""
ssh-keygen -b 2048 -t rsa -f ${TMP_BASE_DIR}/vm2/id_rsa      -C ubuntu@vm2      -q -N ""

echo "Moving ssh keypairs to repo"
mv ${TMP_BASE_DIR}/* .