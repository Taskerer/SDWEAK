#!/bin/bash

# write
write() {
	[[ ! -f "$1" ]] && return 1
	chmod +w "$1" 2> /dev/null
	if ! echo "$2" > "$1" 2> /dev/null
	then
		echo "Failed: $1 → $2"
		return 1
	fi
	echo "$1 → $2"
}

# Check for root permissions and bail if not granted
if [[ "$(id -u)" -ne 0 ]]
then
	echo "No root permissions. Exiting."
	exit 1
fi

# Sync to data in the rare case a device crashes
sync

# fs
write /proc/sys/fs/aio-max-nr 131072
write /proc/sys/fs/epoll/max_user_watches 100000
write /proc/sys/fs/inotify/max_user_watches 65536
write /proc/sys/fs/pipe-max-size 2097152
write /proc/sys/fs/pipe-user-pages-soft 65536

# kernel
write /proc/sys/kernel/perf_cpu_time_max_percent 1
write /proc/sys/kernel/perf_event_max_contexts_per_stack 1
write /proc/sys/kernel/perf_event_max_sample_rate 1
write /proc/sys/kernel/perf_event_max_stack 1
write /proc/sys/kernel/seccomp/actions_logged ""
write /proc/sys/kernel/io_delay_type 3
write /proc/sys/dev/hpet/max-user-freq 2048
write /sys/class/rtc/rtc0/max_user_freq 2048
write /proc/sys/kernel/timer_migration 0
write /proc/sys/kernel/watchdog 0
write /proc/sys/kernel/soft_watchdog 0
write /proc/sys/kernel/nmi_watchdog 0
write /proc/sys/kernel/sched_autogroup_enabled 0
write /proc/sys/kernel/core_pattern /dev/null
write /proc/sys/kernel/core_pipe_limit 0
write /proc/sys/kernel/ftrace_enabled 0
write /proc/sys/kernel/printk_ratelimit_burst 1
write /proc/sys/kernel/printk_devkmsg off
write /proc/sys/debug/exception-trace 0

# vm
write /proc/sys/vm/dirty_background_bytes 209715200
write /proc/sys/vm/dirty_bytes 419430400
write /proc/sys/vm/dirty_expire_centisecs 1500
write /proc/sys/vm/dirty_writeback_centisecs 1500
write /proc/sys/vm/min_free_kbytes 121634
write /proc/sys/vm/hugetlb_optimize_vmemmap 0
write /proc/sys/vm/page-cluster 0
write /proc/sys/vm/page_lock_unfairness 8
write /proc/sys/vm/vfs_cache_pressure 66
write /proc/sys/vm/watermark_scale_factor 125
write /proc/sys/vm/swappiness 40
write /proc/sys/vm/watermark_boost_factor 0
write /proc/sys/vm/stat_interval 15
write /proc/sys/vm/compact_unevictable_allowed 0
write /proc/sys/vm/compaction_proactiveness 10

# mm
write /sys/kernel/mm/transparent_hugepage/enabled always
write /sys/kernel/mm/transparent_hugepage/khugepaged/defrag 1
write /sys/kernel/mm/transparent_hugepage/defrag defer+madvise
write /sys/kernel/mm/ksm/run 0
write /sys/kernel/mm/transparent_hugepage/shmem_enabled advise
write /sys/kernel/mm/transparent_hugepage/khugepaged/pages_to_scan 2048
write /sys/kernel/mm/transparent_hugepage/khugepaged/scan_sleep_millisecs 5000
write /sys/kernel/mm/transparent_hugepage/khugepaged/alloc_sleep_millisecs 50000
write /sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_swap 128

# flash
write /sys/block/zram*/queue/iostats 0
write /sys/block/mmcblk*/queue/iostats 0
write /sys/block/nvme*n*/queue/iostats 0
write /sys/block/zram*/queue/add_random 0
write /sys/block/mmcblk*/queue/add_random 0
write /sys/block/nvme*n*/queue/add_random 0
# zram
write /sys/block/zram*/queue/read_ahead_kb 512
# microSD
write /sys/block/mmcblk*/queue/read_ahead_kb 2048
write /sys/block/mmcblk*/queue/rq_affinity 2
write /sys/block/mmcblk*/queue/wbt_lat_usec 2000
write /sys/block/mmcblk*/queue/iosched/back_seek_penalty 1
write /sys/block/mmcblk*/queue/iosched/fifo_expire_async 200
write /sys/block/mmcblk*/queue/iosched/fifo_expire_sync 100
write /sys/block/mmcblk*/queue/iosched/slice_idle 0
write /sys/block/mmcblk*/queue/iosched/slice_idle_us 0
write /sys/block/mmcblk*/queue/iosched/timeout_sync 100
# nvme
write /sys/block/nvme*n*/queue/read_ahead_kb 1024
write /sys/block/nvme*n*/queue/wbt_lat_usec 999
write /sys/block/nvme*n*/queue/iosched/write_lat_nsec 6000000
write /sys/block/nvme*n*/queue/iosched/read_lat_nsec 1200000

# BORE-scheduler
#write /proc/sys/kernel/sched_bore 1
#write /proc/sys/kernel/sched_burst_cache_lifetime 40000000
#write /proc/sys/kernel/sched_burst_fork_atavistic 2
#write /proc/sys/kernel/sched_burst_penalty_offset 26
#write /proc/sys/kernel/sched_burst_penalty_scale 1000
#write /proc/sys/kernel/sched_burst_smoothness_long 0
#write /proc/sys/kernel/sched_burst_smoothness_short 0
#write /proc/sys/kernel/sched_burst_exclude_kthreads 1
#write /proc/sys/kernel/sched_burst_parity_threshold 1

# debug sched
#write /sys/kernel/debug/sched/features NO_PLACE_LAG
#write /sys/kernel/debug/sched/features NO_RUN_TO_PARITY
#write /sys/kernel/debug/sched/features NEXT_BUDDY
#write /sys/kernel/debug/sched/migration_cost_ns 1000000
#write /sys/kernel/debug/sched/nr_migrate 4
