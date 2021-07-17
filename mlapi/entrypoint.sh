#!/bin/bash
set -e

echo "Create MLAPI config (secrets.ini) based on env variables"
# env | grep "MLAPI_"
# cat ${MLAPI_DIR}/secrets.ini
rm -f ${MLAPI_DIR}/secrets.ini
# for kv in $(env | grep "MLAPI_"); do
#   echo "${kv/MLAPI_}" >> ${MLAPI_DIR}/secrets.ini
# done
envsubst < ${MLAPI_DIR}/secrets.ini.in > ${MLAPI_DIR}/secrets.ini
# cat ${MLAPI_DIR}/secrets.ini
echo "Create MLAPI config (mlapiconfig.ini) based on env variables"
rm -f ${MLAPI_DIR}/mlapiconfig.ini
envsubst < ${MLAPI_DIR}/mlapiconfig.ini.in > ${MLAPI_DIR}/mlapiconfig.ini
echo "Init user by MLAPI_USER and MLAPI_PASSWORD env variables"
# env | grep "MLAPI_"
# python3 ${MLAPI_DIR}/init_user.py
python3 ${MLAPI_DIR}/mlapi_dbuser.py -f -u ${MLAPI_USER} -p ${MLAPI_PASSWORD} -d ${MLAPI_DIR}/db

exec "$@"