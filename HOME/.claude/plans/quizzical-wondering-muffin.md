# Implementation Plan: Refactor encrypt_stdin.pl to use FileCrypto (Issue #1)

## Overview

Refactor `utils/edit/encrypt_stdin.pl` to use `FileCrypto.pm` directly instead of shelling out to `encryptFiles.sh` and `decryptFiles.sh`.

## Current State

`encrypt_stdin.pl` currently:
1. Uses `find_encrypt_command()` / `find_decrypt_command()` to locate shell scripts
2. Calls `system()` with manual stdin/stdout redirection for password prompts
3. Password verification done by attempting actual decryption with shell script

## Target State

Use `FileCrypto.pm` directly (same pattern as `EncryptEditFile.pm`):
1. Create `FileCrypto->new()` instance
2. Call `$crypto->encrypt_files()` with password parameter
3. Use hash-based password verification instead of trial decryption

## Files to Modify

### `utils/edit/encrypt_stdin.pl`

**Add imports:**
```perl
use FileCrypto;
use PasswordManager qw(get_password);
```

**Remove (no longer needed):**
- `find_encrypt_command()` subroutine (lines 400-428)
- `find_decrypt_command()` subroutine (lines 370-398)
- `/dev/tty` stdin redirection logic
- Trial decryption for password verification

**Replace encryption call:**
```perl
# Before: system($encrypt_cmd, "--outdir", $outdir, $temp_filename)
# After:
my $crypto = FileCrypto->new();
my $password = get_password(confirm => 1);

my $result = $crypto->encrypt_files(
    files => [$temp_filename],
    password => $password,
    outdir => $outdir
);

unless ($result->{success}) {
    die "Encryption failed\n";
}

# Store hash for verification
$crypto->store_password_hash($password);
```

**Replace password verification loop:**
```perl
# Before: Trial decrypt with decryptFiles.sh
# After:
print "Password Verification\n";
print "Please enter the password again to verify:\n";

my $verify_password = get_password(confirm => 0);

if ($crypto->verify_password_hash($verify_password)) {
    print "Password verified successfully!\n";
    $password_verified = 1;
} else {
    print "Password verification FAILED!\n";
    # Delete encrypted file and retry
    unlink($encrypted_file);
    # Loop continues...
}

$crypto->clear_password_hash();
```

## Key Changes Summary

| Aspect | Before | After |
|--------|--------|-------|
| Encryption | `system(encryptFiles.sh, ...)` | `$crypto->encrypt_files(...)` |
| Decryption (verify) | `system(decryptFiles.sh, ...)` | `$crypto->verify_password_hash()` |
| Password prompts | Manual /dev/tty redirect | PasswordManager handles it |
| Command lookup | 59 lines of lookup code | Not needed |

## Benefits

- Eliminates ~100 lines of shell-out boilerplate
- No dependency on scripts being in PATH
- Uses battle-tested FileCrypto library
- Consistent with EncryptEditFile.pm pattern
- Better error handling via result hash

## Testing

1. `echo "secret" | encrypt_stdin.pl` - piped input
2. `encrypt_stdin.pl --name test` - interactive input
3. `encrypt_stdin.pl --editor` - editor mode
4. Verify password verification works (enter wrong password on verify)
5. Verify result can be decrypted with `decryptFiles.sh`
