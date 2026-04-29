# macOS Automation

## iTerm2 Tab Title

When starting a session, offer to set the tab title:
- `iterm-set-title "Project Name - Claude Code"`
- Requires iTerm2 Python API enabled (Settings > General > Magic > Enable Python API)
- Locks title so shell can't override it

## Document Commands

Work on any project with markdown documents. **Never operate on documents outside the current project.**

### Create PDF
When Brooke says "create PDF for [document]":
1. Find the markdown file (use glob)
2. Run: `convertproj.sh -f pdf -t bespoke.docx <path>`
3. Output goes to `dist/`

### Email Document
When Brooke says "email [document] to [person]":
1. Check project memory for last sent date
2. Regenerate PDF if markdown modified since last sent
3. Compose in Mail.app via AppleScript — do NOT auto-send, open for review
4. Always CC brooke@oehmsmith.com
5. Default: describe document and highlight recent changes
6. After Brooke confirms sent, record date in project memory

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

### Send Message
When Brooke says "send [person] a message":
1. Compose based on instructions (ask if no content given)
2. Send via Messages.app — **sends immediately**, no review step
3. Confirm what was sent

```bash
osascript -e '
tell application "Messages"
    send "MESSAGE" to buddy "PHONE_OR_EMAIL" of (1st account whose service type = iMessage)
end tell'
```

### Send Calendar Invite
When Brooke says "send calendar invite" or "create a meeting":
1. Look up attendees in project memory
2. Confirm details if not fully specified
3. Create on **Brooke Work** calendar — sends invite automatically
4. Confirm creation

```bash
osascript -e '
tell application "Calendar"
    tell calendar "Brooke Work"
        set startDate to current date
        set year of startDate to YEAR
        set month of startDate to MONTH
        set day of startDate to DAY
        set hours of startDate to START_HOUR
        set minutes of startDate to 0
        set seconds of startDate to 0
        set endDate to current date
        set year of endDate to YEAR
        set month of endDate to MONTH
        set day of endDate to DAY
        set hours of endDate to END_HOUR
        set minutes of endDate to 0
        set seconds of endDate to 0
        set newEvent to make new event with properties {summary:"TITLE", start date:startDate, end date:endDate, location:"LOCATION", description:"DESCRIPTION"}
        make new attendee at end of attendees of newEvent with properties {email:"EMAIL"}
    end tell
end tell'
```

**Notes:** All macOS automation requires privacy permissions (System Settings > Privacy & Security > Automation). Contacts are stored in project memory.
