#!/bin/bash

# Check for root permissions and bail if not granted
if [[ "$(id -u)" -ne 0 ]]; then
    echo "SDWEAK: no root permissions. Exiting." >&2
    exit 1
fi

# Counters
WRITE_OK=0
WRITE_FAIL=0
WRITE_SKIP=0

# Logging helpers
section() { echo ""; echo "── $* ──────────────────────────────────────────────"; }

# write <path> <value>
write() {
    local path="$1" value="$2"

    if [[ ! -f "$path" ]]; then
        echo "SKIP  $path"
        WRITE_SKIP=$(( WRITE_SKIP + 1 ))
        return 1
    fi

    if printf '%s\n' "$value" > "$path" 2>/dev/null; then
        echo "OK    $path ← $value"
        WRITE_OK=$(( WRITE_OK + 1 ))
    else
        echo "FAIL  $path ← $value" >&2
        WRITE_FAIL=$(( WRITE_FAIL + 1 ))
        return 1
    fi
}

# Summary on exit
_summary() {
    echo ""
    echo "── DONE  OK=${WRITE_OK}  FAIL=${WRITE_FAIL}  SKIP=${WRITE_SKIP} ──────────────────────"
}
trap _summary EXIT

# Flush pending I/O before touching scheduler and I/O params
sync

# scx_lavd status
if [[ -r /sys/kernel/sched_ext/state ]]; then
    _scx_state=$(< /sys/kernel/sched_ext/state)
    echo "sched_ext state: ${_scx_state}"
fi

# Debug & FS
section "Debug & FS"
write /proc/sys/debug/exception-trace 0
write /proc/sys/fs/aio-max-nr 1048576

# Kernel
section "Kernel"
write /proc/sys/kernel/watchdog 0
write /proc/sys/kernel/nmi_watchdog 0
write /proc/sys/kernel/soft_watchdog 0
write /proc/sys/kernel/hung_task_timeout_secs 0
write /proc/sys/kernel/perf_cpu_time_max_percent 1
write /proc/sys/kernel/perf_event_max_contexts_per_stack 1
write /proc/sys/kernel/perf_event_max_sample_rate 1
write /proc/sys/kernel/perf_event_max_stack 1
write /proc/sys/kernel/printk "3 3 3 3"
write /proc/sys/kernel/printk_devkmsg off
write /proc/sys/kernel/seccomp/actions_logged ""
write /proc/sys/kernel/sched_autogroup_enabled 0

# Virtual Memory (VM)
section "Virtual Memory"
write /proc/sys/vm/compact_unevictable_allowed 1
write /proc/sys/vm/compaction_proactiveness 0
write /proc/sys/vm/dirty_background_bytes 209715200
write /proc/sys/vm/dirty_bytes 419430400
write /proc/sys/vm/dirty_expire_centisecs 1500
write /proc/sys/vm/dirty_writeback_centisecs 500
write /proc/sys/vm/extfrag_threshold 750
write /proc/sys/vm/min_free_kbytes 131072
write /proc/sys/vm/page-cluster 0
write /proc/sys/vm/page_lock_unfairness 8
write /proc/sys/vm/stat_interval 15
write /proc/sys/vm/swappiness 150
write /proc/sys/vm/vfs_cache_pressure 50
write /proc/sys/vm/watermark_boost_factor 5000
write /proc/sys/vm/watermark_scale_factor 125

# Network Stack
section "Network Stack"
write /proc/sys/net/ipv4/tcp_wmem "4096 16384 16777216"
write /proc/sys/net/core/rmem_max 16777216
write /proc/sys/net/core/wmem_max 16777216

# Memory Management (MM)
section "Memory Management"
write /sys/kernel/mm/ksm/run 0
write /sys/kernel/mm/lru_gen/enabled 0x0007
write /sys/kernel/mm/lru_gen/min_ttl_ms 200
write /sys/kernel/mm/swap/vma_ra_enabled false

# Transparent Hugepages (THP)
section "Transparent HugePages (THP)"
write /sys/kernel/mm/transparent_hugepage/enabled always
write /sys/kernel/mm/transparent_hugepage/defrag defer+madvise
write /sys/kernel/mm/transparent_hugepage/shmem_enabled within_size
write /sys/kernel/mm/transparent_hugepage/khugepaged/defrag 1
write /sys/kernel/mm/transparent_hugepage/khugepaged/pages_to_scan 2048
write /sys/kernel/mm/transparent_hugepage/khugepaged/scan_sleep_millisecs 8000
write /sys/kernel/mm/transparent_hugepage/khugepaged/alloc_sleep_millisecs 30000
write /sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none 409

# NVME
section "NVME"
for QUEUE in /sys/block/nvme*n*/queue; do
    [[ -d "$QUEUE" ]] || continue

    write "$QUEUE/scheduler" kyber
    write "$QUEUE/read_ahead_kb" 1024
    write "$QUEUE/wbt_lat_usec" 0
    write "$QUEUE/rq_affinity" 2
    write "$QUEUE/add_random" 0
    write "$QUEUE/iostats" 0

    write "$QUEUE/iosched/read_lat_nsec" 1000000
    write "$QUEUE/iosched/write_lat_nsec" 3500000
done

# ZRAM
section "ZRAM"
for QUEUE in /sys/block/zram*/queue; do
    [[ -d "$QUEUE" ]] || continue

    write "$QUEUE/read_ahead_kb" 0
    write "$QUEUE/nomerges" 2
    write "$QUEUE/add_random" 0
    write "$QUEUE/iostats" 0
done

# microSD
section "microSD"
for QUEUE in /sys/block/mmcblk*/queue; do
    [[ -d "$QUEUE" ]] || continue

    write "$QUEUE/scheduler" bfq
    write "$QUEUE/nr_requests" 64
    write "$QUEUE/read_ahead_kb" 1024
    write "$QUEUE/rq_affinity" 2
    write "$QUEUE/add_random" 0
    write "$QUEUE/iostats" 0
    write "$QUEUE/wbt_lat_usec" 0

    write "$QUEUE/iosched/slice_idle" 0
    write "$QUEUE/iosched/slice_idle_us" 0
    write "$QUEUE/iosched/fifo_expire_sync" 80
    write "$QUEUE/iosched/timeout_sync" 100
    write "$QUEUE/iosched/back_seek_penalty" 1
done
