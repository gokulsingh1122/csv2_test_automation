#!/bin/sh

# Inputs to this script - set as env
#
# $FILE_NAME - name of file attachment
# $FILE_NAME_WITH_FILE_PATH - full file path
# $TO_ADDRESS - receiver
# $FROM_ADDRESS - SENDER
# $SUBJECT - email subject
# $BODY - email body
# $API_KEY - SendGrid API Key


echo 'encoding $FILE_NAME_WITH_FILE_PATH'

ENCODED_FILE=$(cat -s $FILE_NAME_WITH_FILE_PATH | base64 -w 0)

echo "Encoded file size ${#ENCODED_FILE}"

echo 'generating JSON'

JSON_STRING="{
    \"personalizations\": [{
        \"to\": [
            { \"email\": \"${TO_ADDRESS}\" }
        ],
        \"subject\": \"${SUBJECT}\"}],
    \"from\": {
        \"email\": \"${FROM_ADDRESS}\"
    },
    \"content\": [
        {
            \"type\": \"text/html\",
            \"value\": \"${BODY}\"
        }
    ],
    \"attachments\": [
        {
            \"content\": \"${ENCODED_FILE}\" ,
            \"filename\": \"${FILE_NAME}\" ,
            \"type\": \"text/html\" ,
            \"disposition\": \"attachment\"
        }
    ]
}"


#JSON_STRING=$(printf "$JSON_TEMPLATE" "$TO_ADDRESS" "$SUBJECT" "$FROM_ADDRESS" "$BODY" "$ENCODED_FILE" "$FILE_NAME")

#echo "$JSON_STRING"

AUTH_STR="Authorization: Bearer %s"
AUTH=$(printf "$AUTH_STR" "$API_KEY")


CURL_OUT=$(echo $JSON_STRING | curl -H "$AUTH" -H "Content-Type: application/json" -X POST -d @- https://api.sendgrid.com/v3/mail/send )

echo $CURL_OUT