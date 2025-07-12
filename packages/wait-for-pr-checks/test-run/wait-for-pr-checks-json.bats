#!/usr/bin/env bats

# Load the common test helpers
load test_helpers

setup() {
  setup_test_env
}

teardown() {
  cleanup_test_env
}

@test "outputs JSON with --json flag" {
  write_gh_stub '[{"name":"ci","state":"SUCCESS","link":"https://example.com"}]'
  run "$script" --json
  [ "$status" -eq 0 ]
  # Verify output is valid JSON
  echo "$output" | "$JQ_BIN" . >/dev/null
  [ "$?" -eq 0 ]
  # Verify JSON contains expected fields
  [[ "$(echo "$output" | "$JQ_BIN" -r .status)" == "success" ]]
  [[ "$(echo "$output" | "$JQ_BIN" -r .pending)" == "0" ]]
  [[ "$(echo "$output" | "$JQ_BIN" -r .failed)" == "0" ]]
}

@test "outputs JSON with environment variable" {
  write_gh_stub '[{"name":"ci","state":"SUCCESS","link":"https://example.com"}]'
  WAIT_PR_JSON_OUTPUT=true run "$script"
  [ "$status" -eq 0 ]
  # Verify output is valid JSON
  echo "$output" | "$JQ_BIN" . >/dev/null
  [ "$?" -eq 0 ]
}

@test "outputs JSON with failed status" {
  write_gh_stub '[{"name":"ci","state":"FAILURE","link":"https://example.com"}]'
  run "$script" --json
  [ "$status" -eq 1 ]
  # Verify output is valid JSON
  echo "$output" | "$JQ_BIN" . >/dev/null
  [ "$?" -eq 0 ]
  # Verify JSON contains expected fields
  [[ "$(echo "$output" | "$JQ_BIN" -r .status)" == "failed" ]]
  [[ "$(echo "$output" | "$JQ_BIN" -r .failed)" == "1" ]]
}

@test "outputs JSON with timeout status" {
  write_gh_stub '[{"name":"ci","state":"PENDING","link":"https://example.com"}]'
  run "$script" --json -t 1 -i 1
  [ "$status" -eq 2 ]
  # Verify output is valid JSON
  echo "$output" | "$JQ_BIN" . >/dev/null
  [ "$?" -eq 0 ]
  # Verify JSON contains expected fields
  [[ "$(echo "$output" | "$JQ_BIN" -r .status)" == "timeout" ]]
}
