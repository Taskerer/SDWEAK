#!/bin/bash

# write
write() {
	# Bail out if file does not exist
# Maximum unsigned integ
	[[ ! -f "$1" ]] && return 1

	# Make file writable in case it is not already
	chmod +w "$1" 2> /dev/null

	# Write the new value and bail if there's an error
	if ! echo "$2" > "$1" 2> /dev/null
	then
		echo "Failed: $1 → $2"
		return 1
	fi

	# Log the success
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

write /proc/sys/vm/compaction_proactiveness 5
write /sys/kernel/mm/transparent_hugepage/enabled always
write /sys/kernel/mm/transparent_hugepage/khugepaged/defrag 0
write /sys/kernel/mm/transparent_hugepage/shmem_enabled advise
write /proc/sys/vm/page_lock_unfairness 1

##### CACHYOS SYSCTL VALUE
write /proc/sys/dev/hpet/max-user-freq 3072
write /proc/sys/fs/epoll/max_user_watches 2677492
write /proc/sys/kernel/hardlockup_panic 0
write /proc/sys/kernel/panic_on_oops 0
write /proc/sys/kernel/sched_burst_cache_lifetime 75000000
write /proc/sys/kernel/sched_burst_penalty_scale 1280
write /proc/sys/kernel/sched_burst_penalty_offset 24
write /proc/sys/kernel/sched_burst_fork_atavistic 2
write /proc/sys/kernel/softlockup_panic 0
write /proc/sys/kernel/watchdog_thresh 10
write /proc/sys/kernel/watchdog_cpumask 0-7

write /proc/sys/kernel/split_lock_mitigate 0

write /proc/sys/vm/min_free_kbytes 512000


write /proc/sys/kernel/sched_bore 1

write /proc/sys/kernel/printk "0 0 0 0"

write /proc/sys/kernel/kptr_restrict 2

write /proc/sys/kernel/kexec_load_disabled 1

write /proc/sys/kernel/unprivileged_userns_clone 1

write /proc/sys/kernel/nmi_watchdog 0

write /proc/sys/kernel/sched_burst_fork_atavistic 3

# Limit max perf event processing time to this much CPU usage
write /proc/sys/kernel/perf_cpu_time_max_percent 3

# Group tasks for less stutter but less throughput
write /proc/sys/kernel/sched_autogroup_enabled 0

# Execute child process before parent after fork
write /proc/sys/kernel/sched_child_runs_first 1

# Disable scheduler statistics to reduce overhead
write /proc/sys/kernel/sched_schedstats 0

# Disable unnecessary printk logging
write /proc/sys/kernel/printk_devkmsg off

write /proc/sys/vm/oom_kill_allocating_task 0

# Start non-blocking writeback later
write /proc/sys/vm/dirty_background_ratio 3

# Start blocking writeback later
write /proc/sys/vm/dirty_ratio 30

# Require dirty memory to stay in memory for longer
write /proc/sys/vm/dirty_expire_centisecs 3000

# Run the dirty memory flusher threads less often
write /proc/sys/vm/dirty_writeback_centisecs 3000

# Disable read-ahead for swap devices
write /proc/sys/vm/page-cluster 0

# Update /proc/stat less often to reduce jitter
write /proc/sys/vm/stat_interval 20

write /proc/sys/vm/max_map_count 2147483642

# Fairly prioritize page cache and file structures
write /proc/sys/vm/vfs_cache_pressure 200

write /proc/sys/fs/file-max 2097152

write /proc/sys/net/ipv4/tcp_rfc1337 1

# Enable Explicit Congestion Control
write /proc/sys/net/ipv4/tcp_ecn 1

# Enable fast socket open for receiver and sender
write /proc/sys/net/ipv4/tcp_fastopen 3

# TCP Reduce performance spikes
write /proc/sys/net/ipv4/tcp_timestamps 0

write /proc/sys/net/ipv4/tcp_tw_reuse 1

# Increase netdev receive queue
# May help prevent losing packets
write /proc/sys/net/core/netdev_max_backlog 16384

# Disable TCP slow start after idle
# Helps kill persistent single connection performance
write /proc/sys/net/ipv4/tcp_slow_start_after_idle 0

# Disable SYN cookies
write /proc/sys/net/ipv4/tcp_syncookies 0

write /sys/devices/system/cpu/cpufreq/schedutil/rate_limit_us 6000

# Do not use I/O as a source of randomness
write /sys/block/mmcblk0/queue/add_random 0
write /sys/block/nvme0n1/queue/add_random 0

# Disable I/O statistics accounting
write /sys/block/mmcblk0/queue/iostats 0
write /sys/block/nvme0n1/queue/iostats 0

# Reduce heuristic read-ahead in exchange for I/O latency
write /sys/block/mmcblk0/queue/read_ahead_kb 128
write /sys/block/nvme0n1/queue/read_ahead_kb 128

# Reduce the maximum number of I/O requests in exchange for latency
write /sys/block/mmcblk0/queue/nr_requests 64
write /sys/block/nvme0n1/queue/nr_requests 64

write /proc/sys/debug/kprobes-optimization 1

write /proc/sys/debug/exception-trace 0

write /proc/sys/vm/swappiness 100
write /proc/sys/vm/watermark_boost_factor 0
write /proc/sys/vm/watermark_scale_factor 125

if lsblk -dno NAME,TYPE | grep -qE '^(sd[a-z]|mmcblk[0-9]+)\s+disk'; then
    SD_RULE='ACTION=="add|change", KERNEL=="sd[a-z]|mmcblk[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="kyber"'
fi
cat << EOF | sudo tee /etc/udev/rules.d/64-ioschedulers.rules >/dev/null
ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/scheduler}="kyber"
$SD_RULE
EOF
