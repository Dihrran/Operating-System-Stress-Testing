#!/bin/bash
# =====================================================================
# 5.0.6 I/O Latency + Persistence Guarantees - Stress Test Script
# Runs stress-ng --file and --sync-file concurrently at medium load
# (16 workers each) for >=60s, per Procedure steps 4-6.
# =====================================================================


TEST_DURATION=60
FILE_WORKERS=16
FSYNC_WORKERS=16
LOG_DIR="./stress-ng-logs/io-latency-persistence"

mkdir -p "$LOG_DIR"

file_latency() {
    echo "===== Starting 5.0.6 combined file + sync-file stress test (medium load) ====="
    echo "File workers: ${FILE_WORKERS} | Sync-file workers: ${FSYNC_WORKERS} | Duration: ${TEST_DURATION}s"

    stress-ng --filename "${FILE_WORKERS}" --sync-file "${FSYNC_WORKERS}" \
        --timeout "${TEST_DURATION}s" --metrics-brief \
        2>&1 | tee "${LOG_DIR}/io_latency_persistence_medium.log"

    echo "===== Test completed. Log saved in ${LOG_DIR} ====="
}
