#!/usr/bin/env bats

# Load the common test helpers
load test_helpers

setup() {
  setup_test_env
}

teardown() {
  cleanup_test_env
}

@test "uses custom timeout from environment variable" {
  write_gh_stub '[{"name":"ci","state":"PENDING","link":"https://example.com"}]'
  WAIT_PR_TIMEOUT=1 run "$script" -i 1
  [ "$status" -eq 2 ]
  [[ "$output" == *"Timeout reached after 1 seconds"* ]]
}

@test "uses custom max interval from environment variable" {
  write_gh_stub '[{"name":"ci","state":"PENDING","link":"https://example.com"}]'
  WAIT_PR_MAX_INTERVAL=1 WAIT_PR_TIMEOUT=3 run "$script" -i 1
  [ "$status" -eq 2 ]
  [[ "$output" == *"Waiting 1 seconds"* ]]
}

@test "uses custom initial wait from environment variable" {
  write_gh_stub '[{"name":"ci","state":"PENDING","link":"https://example.com"}]'
  WAIT_PR_INITIAL_WAIT=3 WAIT_PR_TIMEOUT=4 run "$script"
  [ "$status" -eq 2 ]
  [[ "$output" == *"Waiting 3 seconds"* ]]
}

@test "uses no-fail-fast mode from environment variable" {
  write_gh_stub '[{"name":"ci","state":"FAILURE","link":"https://example.com"},{"name":"test","state":"PENDING","link":"https://example.com"}]'
  WAIT_PR_FAIL_FAST=false WAIT_PR_TIMEOUT=1 run "$script" -i 1
  [ "$status" -eq 2 ]
  [[ "$output" == *"No fail-fast mode"* ]]
  [[ "$output" != *"Exiting early due to fail-fast mode"* ]]
}
