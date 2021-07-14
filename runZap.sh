#!/bin/bash
#

IMAGE="owasp/zap2docker-weekly"
URL_API=$1
USER=$2
PASSWORD=$3
JSON=$4
REPORTNAME=$5
USERID=1

TOKEN=$(python getToken.py ${URL_API} ${USER} ${PASSWORD})

echo "----> START ZAP"
echo "----> Building prop file"

cat << EOF > auth.prop
replacer.full_list(0).description=auth1
replacer.full_list(0).enabled=true
replacer.full_list(0).matchtype=REQ_HEADER
replacer.full_list(0).matchstr=Authorization
replacer.full_list(0).regex=false
replacer.full_list(0).replacement=Bearer $TOKEN
formhandler.fields.field\\(0\\).fieldId=userId
formhandler.fields.field\\(0\\).value=${USERID}
formhandler.fields.field\\(0\\).enabled=true                
EOF

docker pull ${IMAGE}
docker run --rm -v `pwd`:/zap/wrk/:rw -t ${IMAGE} zap-api-scan.py \
    -t ${JSON} -f openapi -r ${REPORTNAME} -z "-configfile /zap/wrk/auth.prop" -d


