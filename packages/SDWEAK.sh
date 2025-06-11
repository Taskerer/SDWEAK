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

setpci -v -s '*:*' latency_timer=20
setpci -v -s '0:0' latency_timer=0
setpci -v -d "*:*:04xx" latency_timer=80

# fs
write /proc/sys/fs/aio-max-nr 131072
write /proc/sys/fs/dir-notify-enable 0
write /proc/sys/fs/epoll/max_user_watches 524288
write /proc/sys/fs/inotify/max_queued_events 32768
write /proc/sys/fs/inotify/max_user_watches 1048576
write /proc/sys/fs/pipe-max-size 2097152

# kernel
write /proc/sys/kernel/sched_autogroup_enabled 1
write /proc/sys/kernel/acct 0
write /proc/sys/kernel/core_pattern /dev/null
write /proc/sys/kernel/core_pipe_limit 0
write /proc/sys/kernel/ftrace_enabled 0
write /proc/sys/kernel/hung_task_check_count 131072
write /proc/sys/kernel/hung_task_check_interval_secs 15
write /proc/sys/kernel/hung_task_warnings 3
write /proc/sys/kernel/kexec_load_disabled 1
write /proc/sys/kernel/kexec_load_limit_panic 0
write /proc/sys/kernel/kexec_load_limit_reboot 0
write /proc/sys/kernel/printk_ratelimit_burst 5
write /proc/sys/kernel/unprivileged_bpf_disabled 0
write /proc/sys/kernel/nmi_watchdog 0
write /proc/sys/kernel/perf_cpu_time_max_percent 10
write /proc/sys/kernel/printk_devkmsg off
write /proc/sys/debug/exception-trace 0

# vm
write /proc/sys/vm/dirty_background_bytes 209715200
write /proc/sys/vm/dirty_bytes 419430400
write /proc/sys/vm/dirty_expire_centisecs 1500
write /proc/sys/vm/dirty_writeback_centisecs 1500
write /proc/sys/vm/min_free_kbytes 121634
write /proc/sys/vm/hugetlb_optimize_vmemmap 1
write /proc/sys/vm/page-cluster 0
write /proc/sys/vm/page_lock_unfairness 8
write /proc/sys/vm/vfs_cache_pressure 66
write /proc/sys/vm/watermark_scale_factor 125
write /proc/sys/vm/swappiness 40
write /proc/sys/vm/watermark_boost_factor 0

# mm
write /sys/kernel/mm/transparent_hugepage/enabled always
write /sys/kernel/mm/transparent_hugepage/khugepaged/defrag 1

# flash
write /sys/block/mmcblk0/queue/add_random 0
write /sys/block/nvme0n1/queue/add_random 0
write /sys/block/mmcblk0/queue/iostats 0
write /sys/block/nvme0n1/queue/iostats 0

# bore
write /proc/sys/kernel/sched_bore 1
write /proc/sys/kernel/sched_burst_cache_lifetime 40000000
write /proc/sys/kernel/sched_burst_fork_atavistic 2
write /proc/sys/kernel/sched_burst_penalty_offset 26
write /proc/sys/kernel/sched_burst_penalty_scale 1000
write /proc/sys/kernel/sched_burst_smoothness_long 0
write /proc/sys/kernel/sched_burst_smoothness_short 0
write /proc/sys/kernel/sched_burst_exclude_kthreads 1
write /proc/sys/kernel/sched_burst_parity_threshold 1
