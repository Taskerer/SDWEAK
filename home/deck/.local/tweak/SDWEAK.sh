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
write /sys/kernel/mm/transparent_hugepage/enabled always
write /sys/kernel/mm/transparent_hugepage/khugepaged/defrag 0
write /sys/kernel/mm/transparent_hugepage/shmem_enabled advise

# kernel
write /proc/sys/kernel/split_lock_mitigate 0
write /proc/sys/kernel/unprivileged_userns_clone 1
write /proc/sys/kernel/nmi_watchdog 0
write /proc/sys/kernel/perf_cpu_time_max_percent 3
write /proc/sys/kernel/sched_autogroup_enabled 0
write /proc/sys/kernel/sched_child_runs_first 1
write /proc/sys/kernel/sched_schedstats 0
write /proc/sys/kernel/printk_devkmsg off
write /proc/sys/debug/kprobes-optimization 1
write /proc/sys/debug/exception-trace 0

# vm
write /proc/sys/vm/page_lock_unfairness 1
write /proc/sys/vm/compaction_proactiveness 5
write /proc/sys/vm/oom_kill_allocating_task 0
write /proc/sys/vm/dirty_background_ratio 3
write /proc/sys/vm/dirty_ratio 30
write /proc/sys/vm/dirty_expire_centisecs 3000
write /proc/sys/vm/dirty_writeback_centisecs 3000
write /proc/sys/vm/page-cluster 0
write /proc/sys/vm/stat_interval 20
write /proc/sys/vm/vfs_cache_pressure 200
write /proc/sys/vm/swappiness 100
write /proc/sys/vm/watermark_boost_factor 0
write /proc/sys/vm/watermark_scale_factor 125

# net
write /proc/sys/net/ipv4/tcp_rfc1337 1
write /proc/sys/net/ipv4/tcp_fastopen 3
write /proc/sys/net/ipv4/tcp_tw_reuse 1
write /proc/sys/net/core/netdev_max_backlog 16384
write /proc/sys/net/ipv4/tcp_slow_start_after_idle 0

# flash
write /sys/block/mmcblk0/queue/add_random 0
write /sys/block/nvme0n1/queue/add_random 0
write /sys/block/mmcblk0/queue/iostats 0
write /sys/block/nvme0n1/queue/iostats 0
write /sys/block/mmcblk0/queue/read_ahead_kb 128
write /sys/block/nvme0n1/queue/read_ahead_kb 128
write /sys/block/mmcblk0/queue/nr_requests 64
write /sys/block/nvme0n1/queue/nr_requests 64
if lsblk -dno NAME,TYPE | grep -qE '^(sd[a-z]|mmcblk[0-9]+)\s+disk'; then
    SD_RULE='ACTION=="add|change", KERNEL=="sd[a-z]|mmcblk[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="kyber"'
fi
cat << EOF | sudo tee /etc/udev/rules.d/64-ioschedulers.rules >/dev/null
ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/scheduler}="kyber"
$SD_RULE
EOF
# ZSWAP
write /sys/module/zswap/parameters/enabled 1
write /sys/module/zswap/parameters/compressor lz4
write /sys/module/zswap/parameters/zpool z3fold
write /sys/module/zswap/parameters/max_pool_percent 25
