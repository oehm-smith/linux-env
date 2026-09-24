# Coding Standards

## Writing Code

- Make the SMALLEST reasonable changes to achieve the outcome.
- Prefer simple, clean, maintainable solutions over clever ones. Readability trumps conciseness or performance.
- Reduce code duplication, even if refactoring takes extra effort.
- NEVER throw away or rewrite implementations without EXPLICIT permission from Brooke.
- Get Brooke's explicit approval before implementing backward compatibility.
- Match the style and formatting of surrounding code. Consistency within a file trumps external standards.
- Do not manually change whitespace that doesn't affect execution. Use a formatting tool.
- Fix bugs immediately when found. Don't ask permission.
- **nvm is already loaded** — NEVER prefix commands with `source "$HOME/.nvm/nvm.sh"` or `nvm use`. Just run `pnpm`, `node`, etc. directly. This applies to subagent prompts too.

## Design Principles

- **YAGNI**: Don't add features we don't need right now.
- When it doesn't conflict with YAGNI, architect for extensibility.
- Follow SOLID principles and apply GoF design patterns where appropriate.
- **Thin UI layers** — HARD GATE. Run this check before ANY commit that touches a CLI subcommand handler, HTTP route handler, or WebUI controller. Every violation Brooke has caught has been on a "small mechanical" change where I skipped this check — treat every UI touch as needing it, no matter how small.

  A UI handler is allowed to do EXACTLY these four things:
  1. Parse args / request body / user input.
  2. Call ONE core function (which owns Config load, DB open, business logic, validation against config/registry).
  3. Format the return value for the transport (stdout, HTTP response body, HTML template).
  4. Choose an exit code / HTTP status.

  Concrete red flags that mean "move this to core":
  - `load_config(...)` in a UI handler (except for pure rendering data like path formatting — even then, prefer the core function to return what's needed).
  - `Database(...)` construction in a UI handler.
  - Any direct `db.<method>()` call from a UI handler.
  - Arg validation that references config or registry contents ("is this a valid subject?" "is this a known bill_type?"). Core knows its own config; UI just passes the raw string.
  - Mutual-exclusion checks between args that require domain knowledge to reason about. Core raises `ValueError`; UI translates to exit code / HTTP status.
  - Error messages that describe internal state ("Configured subjects: [...]"). Core builds the message; UI prints it.

  If you catch yourself writing "just a small UI helper with a bit of logic", stop. Add a core function that takes the raw args, returns the result. If the core function needs a callback for progress streaming or an interactive prompt, pass it in. UI's job is presentation and transport — nothing else.

  Refactor cost: usually adding one `run_X(*, config_path, ...args...)` wrapper to a core module and slimming the handler to 5-10 lines. Cheap. Do it.
- **Classes vs functions**: Use a class when functions share state, have a lifecycle, or thread the same first argument. Use functions for pure transformations and one-shot operations. 3+ functions with the same first parameter = a class.

## Naming

Names describe WHAT code does, not HOW it's implemented or its history.

- NEVER use implementation details in names (`ZodValidator`, `MCPWrapper`, `JSONParser`)
- NEVER use temporal context (`NewAPI`, `LegacyHandler`, `UnifiedTool`, `EnhancedParser`)
- NEVER use pattern names unless they add clarity (prefer `Tool` over `ToolFactory`)

Domain-driven examples: `Tool` not `AbstractToolInterface`, `Registry` not `ToolRegistryManager`, `execute()` not `executeToolWithValidation()`

## Comments

- Comments explain WHAT or WHY, never that something is "improved", "better", "new", or "enhanced"
- No instructional comments ("copy this pattern", "use this instead")
- No temporal context ("recently refactored", "moved from X")
- When refactoring, remove stale comments — don't add ones explaining the refactoring
- NEVER remove comments unless you can PROVE they are actively false
- If you catch yourself writing "new", "old", "legacy", "wrapper", "unified" — STOP and find a name describing actual purpose

## File Headers

All code files should start with a 2-line `ABOUTME:` comment (greppable). Enforced by PostToolUse hook — you'll be warned if missing.

For complex modules, expand with PURPOSE, ARCHITECTURE CONTEXT, WHY THIS APPROACH, RELATED FILES sections.

## Docstrings

**MANDATORY**: Every function, method, and class MUST have a docstring — including code you modify that lacks one. Private helpers need at least one line.

**Python style**: Google-style (Sphinx-compatible via `sphinx.ext.napoleon`).
**Required sections**: One-line summary (imperative mood), `Args:`, `Returns:` (omit for None), `Raises:` (if relevant).

```python
def buy_shares(ticker: str, units: Decimal, price: Decimal) -> Transaction:
    """Record a buy transaction and update the holding.

    Args:
        ticker: ASX ticker symbol (e.g. "CBA.AX"). Case-insensitive.
        units: Number of units purchased. Must be positive.
        price: Price per unit in the holding's currency.

    Returns:
        The newly created Transaction record.

    Raises:
        ValueError: If the ticker is not a known holding.
    """
```
