# Send Message via iMessage

Send an iMessage/SMS to a contact.

## Usage
- `/send-message <person> <message>` — send a message to a contact
- Also triggered by natural language: "message Jo to say ...", "SMS her that ...", "text Jo ...", etc.

## Instructions

1. Look up the recipient's phone number or Apple ID in project memory
2. Compose the message based on Brooke's instructions
3. If no specific content given, ask what to say
4. Send via Messages.app (iMessage) using AppleScript — sends immediately (no review step, unlike email)
5. Confirm to Brooke what was sent

## AppleScript template

```bash
osascript -e '
tell application "Messages"
    send "MESSAGE" to buddy "PHONE_OR_EMAIL" of (1st account whose service type = iMessage)
end tell'
```

**Note:** Requires macOS privacy permissions for Messages automation. Contact identifiers are stored in project memory.
