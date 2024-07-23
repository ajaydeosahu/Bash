#!/bin/bash
SLACK_WEBHOOK_URL="https://hooks.slack.com/services/TB5FXBSUE/B072UK65309/LW9htUs7B6U0lAXY32efL8"
CERT_PATH="/etc/letsencrypt/live/dev-backend.non-prod.superiorgroup.com-0002/cert.pem"
CERT_NAME="dev"
EXPIRY_DATE=$(openssl x509 -in "$CERT_PATH" -dates | grep 'notAfter' | cut -d= -f2)
EXPIRY_TIMESTAMP=$(date -d "$EXPIRY_DATE" +%s)
CURRENT_TIMESTAMP=$(date +%s)
THRESHOLD=$((10 * 24 * 60 * 60)) # 10 days in seconds


if (( EXPIRY_TIMESTAMP - CURRENT_TIMESTAMP < THRESHOLD )); then
                 MESSAGE="SSL certificate for $CERT_NAME is about to expire. Please renew it soon."
         else
                          MESSAGE="SSL certificate for $CERT_NAME is not due for renewal."
fi

JSON_PAYLOAD=$(cat <<EOF
{
  "text": "$MESSAGE"
}
EOF
)

# Send the message to Slack
curl -X POST -H 'Content-type: application/json' --data "$JSON_PAYLOAD" "$SLACK_WEBHOOK_URL"
