# Security

## Dependencies

- Verify ALL packages before installation: `npm audit`, Snyk, Socket.dev, manual reputation review
- Automated security checks in CI/CD
- Never commit secrets — use .env files (gitignored), environment variables, or secret managers

## Code Security

- Input validation on all user-facing functions
- Output sanitization to prevent injection attacks
- Error messages must not leak sensitive information
- Logging must exclude PII and credentials

## GenAI/RAG

For GenAI and RAG applications, use the design phase security-audit skill for detailed checklists.

Key principles: prompt injection prevention, PII protection in embeddings/logs, API keys in env vars only, output content moderation, zero-trust for AI components.
