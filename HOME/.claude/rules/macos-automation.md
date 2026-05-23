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

## Calendar (`~/bin/cal`)

Python CLI for Calendar.app. Reads via `icalBuddy` (fast, handles recurring events correctly); writes via osascript. Use this — do NOT shell out to raw `osascript -e 'tell application "Calendar"...'`.

Prerequisite: `brew install ical-buddy`.

### `cal add` — create event / send invite
When Brooke says "send calendar invite", "create a meeting", or "add to calendar":
1. Look up attendees in project memory
2. Confirm details if not fully specified
3. Run `cal add` — defaults to the **Brooke Work** calendar
4. Confirm creation back to Brooke

```
cal add "Project review" --start "2026-06-01 14:00" --duration 60
cal add "Dentist" --start "tomorrow 09:30" --duration 30 --calendar "Brooke"
cal add "Stand-up" --start "today 10:00" --end "today 10:15" --attendees "alice@x.com,bob@y.com" --location "Zoom"
cal add "Public holiday" --start "2026-06-09" --all-day --calendar "Brooke"
```

Start/end accept: `today`, `tomorrow`, `+3d`, `next monday`, `YYYY-MM-DD`, any of the above with optional ` HH:MM`. Either `--end` or `--duration` (minutes); default 60 min if neither.

Adding `--attendees` sends invitations automatically.

### `cal list` — upcoming events + query
```
cal list                                        # today + next 7 days
cal list --days 14
cal list --from "2026-06-01" --to "2026-06-15"  # explicit range
cal list --calendar "Brooke Work"
cal list --name "standup"                       # title regex
cal list --location "zoom"                      # location regex
cal list --notes "Q3 plan"                      # description regex
cal list --attendees "alice@"                   # attendee regex
cal list --no-all-day                           # hide birthdays/holidays
cal list --all-day-only
```

Text filters are regex, case-insensitive by default. Add `--case-sensitive` or use an inline `(?-i:...)` group for case-sensitive matching. Filters compose freely.

## Reminders (`~/bin/remind`)

Python CLI for Apple Reminders. All operations via `reminders-cli` (Reminders.app AppleScript is unusably slow at scale and writes to existing reminders silently fail). Use this — do NOT shell out to raw osascript for reminders.

Prerequisite: `brew install keith/formulae/reminders-cli`.

**CRITICAL behavioural rule — never auto-complete reminders.**
Only call `remind done <id>` when Brooke explicitly tells you a reminder is done, by name or short id. Inferring completion from context (e.g. "we shipped that PR" → ticking off a related reminder) is FORBIDDEN. Brooke's biggest problem is reminders silently disappearing on him; an over-eager tick erases his trust in the tool. When unsure, ASK.

### `remind list` — triage view + query
```
remind list                              # HIGH PRIORITY → DUE TODAY → OVERDUE (newest first)
remind list --list "Work"                # filter to one list
remind list --show nodue                 # also include items with no due date
remind list --show all                   # everything, including snoozed/upcoming
remind list --all                        # alias for --show all
remind list --name "ring|call|email"     # title regex
remind list --notes "ABC"                # notes regex
remind list --priority high              # one of high/medium/low/none
remind list --due-from "2026-04-01" --due-to "2026-05-01"
remind list --no-due                     # items without a due date only
```

Default view hides snoozed/upcoming and items without due dates; counts appear in a footer with the hint to use `--show`.

Any query filter (`--name`, `--notes`, `--priority`, `--due-from`, `--due-to`, `--no-due`) implicitly flips visibility to `--show all` so filtered matches aren't hidden. Text filters are regex, case-insensitive by default (`--case-sensitive` or inline `(?-i:...)` to override). Reminders themselves have no tags — Apple doesn't expose them through any scriptable API — so `--list` and `--name` are the categorization axes.

### `remind add` — create a reminder
```
remind add "Send tax docs" --list "Work" --due "tomorrow 17:00" --priority high
remind add "Buy milk" --list "Shopping"
remind add "Plan holiday" --due "+2w" --notes "Need to book by end of month"
```

`--due` accepts: `today`, `tomorrow`, `+3d`, `+1w`, `next monday`, `YYYY-MM-DD`, with optional ` HH:MM`. `--priority high|medium|low`.

### `remind snooze` — push to a future date
```
remind snooze abc12345 tomorrow
remind snooze abc12345 +3d
remind snooze abc12345 "next monday 09:00"
remind snooze abc12345 2026-06-15
```

Accepts the short hex id from `remind list` (4+ chars, must be unique) or the full `x-apple-reminder://...` URL.

Implementation note: snooze is implemented as add-new-then-delete-old (because no available macOS API can edit a reminder's due date reliably). The reminder's UUID changes after snooze; refer to it by the new short id from the next `remind list` output.

### `remind done` — explicit completion only
```
remind done abc12345
```

See critical rule above. Never call without Brooke explicitly naming the reminder/id.

There is intentionally **no `remind delete`** and **no `cal delete`** — completion or letting events pass is the only "remove" path.

**Notes:** All macOS automation requires privacy permissions (System Settings > Privacy & Security > Automation). Contacts are stored in project memory.
