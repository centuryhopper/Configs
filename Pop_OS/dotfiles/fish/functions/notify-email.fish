function notify-email --description 'Email myself a message'
    set -l msg "$argv"
    test -z "$msg"; and set msg Done
    set -l body (jq -n \
        --arg msg "$msg" \
        '{from: "Alerts <alerts@leoums.dev>", to: ["lynnfavor7@gmail.com"], subject: $msg, text: $msg}')
    curl -s -X POST https://api.resend.com/emails \
        -H "Authorization: Bearer $RESEND_API_KEY" \
        -H "Content-Type: application/json" \
        -d "$body" >/dev/null
end
