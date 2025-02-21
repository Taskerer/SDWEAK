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

# dev/debug
write /proc/sys/dev/hpet/max-user-freq 1000

# fs
write /proc/sys/fs/aio-max-nr 131072
write /proc/sys/fs/dir-notify-enable 0
write /proc/sys/fs/epoll/max_user_watches 524288
write /proc/sys/fs/inotify/max_queued_events 32768
write /proc/sys/fs/inotify/max_user_watches 1048576
write /proc/sys/fs/pipe-max-size 2097152

# kernel
write /proc/sys/kernel/acct 0
write /proc/sys/kernel/core_pattern core.%p
write /proc/sys/kernel/core_pipe_limit 4
write /proc/sys/kernel/ftrace_enabled 0
write /proc/sys/kernel/hung_task_check_count 1048576
write /proc/sys/kernel/hung_task_check_interval_secs 30
write /proc/sys/kernel/hung_task_warnings 5
write /proc/sys/kernel/kexec_load_disabled 1
write /proc/sys/kernel/kexec_load_limit_panic 0
write /proc/sys/kernel/kexec_load_limit_reboot 0
write /proc/sys/kernel/msgmax 16384
write /proc/sys/kernel/msgmnb 65536
write /proc/sys/kernel/msgmni 64000
write /proc/sys/kernel/perf_event_max_sample_rate 5000
write /proc/sys/kernel/perf_event_paranoid -1
write /proc/sys/kernel/printk_ratelimit_burst 20
write /proc/sys/kernel/perf_event_max_stack 64
write /proc/sys/kernel/random/write_wakeup_threshold 512
write /proc/sys/kernel/randomize_va_space 1
write /proc/sys/kernel/sched_cfs_bandwidth_slice_us 1000
write /proc/sys/kernel/sched_deadline_period_min_us 50
write /proc/sys/kernel/seccomp/actions_logged kill_process kill_thread trap errno
write /proc/sys/kernel/threads-max 262144
write /proc/sys/kernel/unprivileged_bpf_disabled 1
write /proc/sys/kernel/user_events_max 65536
write /proc/sys/kernel/warn_limit 1000
write /proc/sys/kernel/watchdog 0
write /proc/sys/kernel/nmi_watchdog 0
write /proc/sys/kernel/perf_cpu_time_max_percent 10
write /proc/sys/kernel/printk_devkmsg off
write /proc/sys/debug/exception-trace 0

# user
write /proc/sys/user/max_fanotify_marks 262144
write /proc/sys/user/max_inotify_watches 1048576

# vm
write /proc/sys/vm/dirty_background_ratio 5
write /proc/sys/vm/dirty_ratio 15
write /proc/sys/vm/dirty_expire_centisecs = 6000
write /proc/sys/vm/hugetlb_optimize_vmemmap 1
write /proc/sys/vm/page-cluster 2
write /proc/sys/vm/page_lock_unfairness 8
write /proc/sys/vm/vfs_cache_pressure 50
write /proc/sys/vm/watermark_scale_factor 200
write /proc/sys/vm/swappiness 100

# mm
write /sys/kernel/mm/transparent_hugepage/enabled madvise
write /sys/kernel/mm/transparent_hugepage/khugepaged/defrag 1
write /sys/kernel/mm/transparent_hugepage/shmem_enabled always

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

if lsblk -dno NAME,TYPE | grep -qE '^(sd[a-z]|mmcblk[0-9]+)\s+disk'; then
    SD_RULE='ACTION=="add|change", KERNEL=="sd[a-z]|mmcblk[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="kyber"'
fi
cat << EOF | sudo tee /etc/udev/rules.d/64-ioschedulers.rules >/dev/null
ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/scheduler}="kyber"
$SD_RULE
EOF
