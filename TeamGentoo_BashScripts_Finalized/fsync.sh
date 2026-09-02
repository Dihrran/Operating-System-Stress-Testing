#!/bin/bash
# =====================================================================
# 5.0.2 Flushes data from a file to memory (fsync) - Stress Test Script
# Runs stress-ng --fsync at low / medium / high concurrency levels,
# with a 60s recovery period between each run
# =====================================================================

TEST_DURATION=60
RECOVERY_DURATION=60
LOG_DIR="./logs"

mkdir -p "$LOG_DIR"

run_fsync() 
{
    local level="$1"
    local threads="$2"

    echo ">>> [${level^^} LOAD] Running stress-ng --sync-file with ${threads} threads"
    stress-ng --sync-file "$threads" --timeout "${TEST_DURATION}s" --metrics-brief \
        2>&1 | tee "${LOG_DIR}/fsync_${level}_${threads}threads.log"

    echo ">>> [${level^^} LOAD] Test finished. Recovering for ${RECOVERY_DURATION}s"
    sleep "$RECOVERY_DURATION"
}

stress_flush() 
{
    echo "===== Starting 5.0.2 fsync stress test suite ====="

    run_fsync "low" 8
    run_fsync "medium" 32
    run_fsync "high" 64

    echo "===== All fsync stress tests completed. Logs saved in ${LOG_DIR} ====="
}

