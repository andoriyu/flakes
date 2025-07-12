#!/usr/bin/env bash
# Common test helpers for wait-for-pr-checks tests

# Create a temporary directory for test files
setup_test_env() {
  TMPDIR="$BATS_TEST_DIRNAME/tmp"
  mkdir -p "$TMPDIR"
  ln -s "$(command -v jq)" "$TMPDIR/jq"
  PATH="$TMPDIR:$PATH"
  export PATH JQ_BIN="$TMPDIR/jq"
  
  # Set script path
  script="${WAIT_FOR_PR_CHECKS_BIN:-$(realpath "$BATS_TEST_DIRNAME/../../../scripts/bin/wait-for-pr-checks")}"
  export script
}

# Clean up temporary files
cleanup_test_env() {
  rm -rf "$TMPDIR"
}

# Create a GitHub CLI stub that returns predefined JSON
write_gh_stub() {
  local json="$1"
  cat >"$TMPDIR/gh" <<EOF
#!/bin/sh
echo '${json}'
EOF
  chmod +x "$TMPDIR/gh"
}
