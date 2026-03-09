List available development methodologies and help select one for the current project.

## Instructions

1. **Read all `.md` files** in `~/.claude/methodologies/` directory
2. **Extract the first heading** from each file as its name and description
3. **Present the list** to the user:

```
Available methodologies:

1. SRDD — Spec-Roundtrip Driven Development (structured, 6-phase cycle)
2. SSRDD — Scaled SRDD (multi-domain coordination wrapper over SRDD)
3. Vibe — Minimal process for scripts, prototypes, quick tasks
[... any others found ...]
```

4. **If the user provides an argument** (`/methodologies srdd`), read and summarize that methodology file
5. **If no argument**, present the list and ask which methodology to use for the current project
6. **When a methodology is selected**, read the full file and confirm:

```
"Loaded [methodology name]. I'll follow this process for the current project.
Key points: [2-3 sentence summary of what this means for our workflow]"
```

**Recommendation hints** (suggest, don't force):

| Project Type | Suggested |
|---|---|
| Scripts, utils, < 5 files | Vibe |
| Standard features, single domain | SRDD |
| Multi-service, multi-domain systems | SSRDD |
