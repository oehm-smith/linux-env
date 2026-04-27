Scan the current project's dependencies for known vulnerabilities and supply chain risks.

## Instructions

1. **Detect project type** by checking for these files in the current working directory:
   - Python: `pyproject.toml`, `requirements.txt`, `uv.lock`, `Pipfile`, `setup.py`
   - Node: `package.json`, `pnpm-lock.yaml`, `package-lock.json`, `yarn.lock`

2. **For Python projects**, run in order of preference:
   - If `uv.lock` exists: `uv audit`
   - If `uv` is available: `uv audit`
   - If `pip-audit` is available: `pip-audit`
   - Otherwise: suggest installing `uv` or `pip-audit`

3. **For Node projects**, run:
   - If `pnpm-lock.yaml` exists: `pnpm audit`
   - If `package-lock.json` exists: `npm audit`
   - If `yarn.lock` exists: `yarn audit`

4. **Cross-reference against blocklist**: Read `~/.claude/scripts/known-malicious-packages.txt` and check if any listed packages appear in the project's dependency tree (including transitive dependencies).

5. **Check installed versions** against known-compromised versions:
   - litellm: 1.82.7, 1.82.8
   - telnyx: 4.87.1, 4.87.2
   - axios (npm): 1.14.1, 0.30.4

6. **Report findings** in a clear table:
   - Package name
   - Installed version
   - Vulnerability ID (CVE/GHSA if available)
   - Severity (Critical/High/Medium/Low)
   - Recommended action

7. If no vulnerabilities found, confirm the project is clean.

## Notes
- This is a READ-ONLY operation. Do not modify any files.
- If both Python and Node dependencies exist, scan both.
- For monorepos, check all workspace packages.
