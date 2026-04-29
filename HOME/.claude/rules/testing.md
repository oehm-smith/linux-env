# Testing

- ALL test failures are YOUR RESPONSIBILITY, even if they're not your fault. Broken Windows theory applies.
- Never delete a failing test. Raise the issue with Brooke.
- Tests MUST comprehensively cover ALL functionality.
- NEVER write tests that test mocked behavior. If you find such tests, STOP and warn Brooke.
- NEVER use mocks in end-to-end tests. Always use real data and real APIs.
- NEVER ignore system or test output — logs often contain CRITICAL information.
- Test output MUST be pristine. If a test intentionally triggers errors, capture and validate the error output is as expected.
