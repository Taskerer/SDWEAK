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

# mm
write /sys/kernel/mm/transparent_hugepage/enabled madvise
write /sys/kernel/mm/transparent_hugepage/khugepaged/defrag 1
write /sys/kernel/mm/transparent_hugepage/shmem_enabled advise

# kernel
write /proc/sys/kernel/watchdog_cpumask 0-7
write /proc/sys/kernel/split_lock_mitigate 0
write /proc/sys/kernel/printk "3 3 3 3"
write /proc/sys/kernel/unprivileged_userns_clone 1
write /proc/sys/kernel/nmi_watchdog 0
write /proc/sys/kernel/perf_cpu_time_max_percent 2
write /proc/sys/kernel/sched_autogroup_enabled 0
write /proc/sys/kernel/sched_child_runs_first 1
write /proc/sys/kernel/sched_schedstats 0
write /proc/sys/kernel/printk_devkmsg off
write /proc/sys/debug/kprobes-optimization 1
write /proc/sys/debug/exception-trace 0

# vm
write /proc/sys/vm/min_free_kbytes 8192
write /proc/sys/vm/page_lock_unfairness 2
write /proc/sys/vm/compaction_proactiveness 5
write /proc/sys/vm/oom_kill_allocating_task 0
write /proc/sys/vm/dirty_background_ratio 10
write /proc/sys/vm/dirty_ratio 40
write /proc/sys/vm/dirty_expire_centisecs 3000
write /proc/sys/vm/dirty_writeback_centisecs 3000
write /proc/sys/vm/page-cluster 0
write /proc/sys/vm/stat_interval 1
write /proc/sys/vm/max_map_count 2147483642
write /proc/sys/vm/vfs_cache_pressure 50
write /proc/sys/vm/swappiness 100
write /proc/sys/vm/watermark_boost_factor 0
write /proc/sys/vm/watermark_scale_factor 125

# fs
write /proc/sys/fs/epoll/max_user_watches 917504
write /proc/sys/fs/file-max 524288

# net
write /proc/sys/net/ipv4/tcp_rfc1337 1
write /proc/sys/net/ipv4/tcp_fastopen 3
write /proc/sys/net/ipv4/tcp_tw_reuse 1
write /proc/sys/net/core/netdev_max_backlog 16384
write /proc/sys/net/ipv4/tcp_slow_start_after_idle 0

# cpu
write /sys/devices/system/cpu/cpufreq/schedutil/rate_limit_us 1000

# flash
write /sys/block/mmcblk0/queue/add_random 0
write /sys/block/nvme0n1/queue/add_random 0
write /sys/block/mmcblk0/queue/iostats 0
write /sys/block/nvme0n1/queue/iostats 0
write /sys/block/mmcblk0/queue/nr_requests 32
write /sys/block/nvme0n1/queue/nr_requests 32

if lsblk -dno NAME,TYPE | grep -qE '^(sd[a-z]|mmcblk[0-9]+)\s+disk'; then
    SD_RULE='ACTION=="add|change", KERNEL=="sd[a-z]|mmcblk[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="kyber"'
fi
cat << EOF | sudo tee /etc/udev/rules.d/64-ioschedulers.rules >/dev/null
ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/scheduler}="kyber"
$SD_RULE
EOF
