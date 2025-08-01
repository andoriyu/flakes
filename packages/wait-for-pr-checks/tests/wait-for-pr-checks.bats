#!/usr/bin/env bats

setup() {
  TMPDIR="$BATS_TEST_DIRNAME/tmp"
  mkdir -p "$TMPDIR"
  ln -s "$(command -v jq)" "$TMPDIR/jq"
  PATH="$TMPDIR:$PATH"
  export PATH JQ_BIN="$TMPDIR/jq"
}

teardown() {
  rm -rf "$TMPDIR"
}

write_gh_stub() {
  local json="$1"
  cat >"$TMPDIR/gh" <<EOF2
#!/bin/sh
echo '${json}'
EOF2
  chmod +x "$TMPDIR/gh"
}

script="${WAIT_FOR_PR_CHECKS_BIN:-$(realpath "$BATS_TEST_DIRNAME/../../../scripts/bin/wait-for-pr-checks")}"

@test "displays help message with --help flag" {
  run "$script" --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage: wait-for-pr-checks"* ]]
}

@test "exits with success when all checks pass" {
  write_gh_stub '[{"name":"ci","state":"SUCCESS","link":"https://example.com"}]'
  run "$script"
  [ "$status" -eq 0 ]
}

@test "exits with failure when a check fails" {
  write_gh_stub '[{"name":"ci","state":"FAILURE","link":"https://example.com"}]'
  run "$script"
  [ "$status" -eq 1 ]
}

@test "exits with code 2 when timeout is reached" {
  write_gh_stub '[{"name":"ci","state":"PENDING","link":"https://example.com"}]'
  run "$script" -t 1 -i 1
  [ "$status" -eq 2 ]
}

@test "waits until minimum checks are present" {
  write_gh_stub '[{"name":"ci","state":"SUCCESS","link":"https://example.com"}]'
  run "$script" --min-checks 2 -t 1 -i 1
  [ "$status" -eq 2 ]
}
