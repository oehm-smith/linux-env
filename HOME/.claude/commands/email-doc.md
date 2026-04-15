# Email Document

Compose an email with a PDF document attached, opened in Mail.app for review before sending.

## Usage
- `/email-doc <document> to <person>` — email a document to a recipient
- Also triggered by natural language: "email ... to Jo", "send ... to Jo by email", etc.

## Instructions

1. Check project memory for the document's last sent date
2. If the markdown source was modified since last sent (or never sent), regenerate the PDF first using `convertproj.sh`
3. Compose in Mail.app via AppleScript — do NOT auto-send, open for review
4. **Always CC brooke@oehmsmith.com**
5. Default behaviour (if no specific message given): describe the document and highlight recent changes since last sent
6. After Brooke confirms it was sent, record the date/time in project memory under "Documents sent log"
7. Recipient contacts are stored in project memory — check there for name, email, phone

## AppleScript template

```bash
osascript -e '
tell application "Mail"
    set newMsg to make new outgoing message with properties {subject:"SUBJECT", content:"BODY", visible:true}
    tell newMsg
        make new to recipient with properties {name:"NAME", address:"EMAIL"}
        make new cc recipient with properties {name:"Brooke", address:"brooke@oehmsmith.com"}
        make new attachment with properties {file name:POSIX file "PDF_PATH"}
    end tell
    activate
end tell'
```
