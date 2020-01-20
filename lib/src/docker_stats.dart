class DockerContainerStats {
  final int num_procs;
  final DateTime read;
  final int pidStats;
  final int now_cpu_stats_total_usage;
  final int now_cpu_stats_system_usage;
  final int now_cpu_stats_online_cpu;
  final int pre_cpu_stats_total_usage;
  final int pre_cpu_stats_system_usage;
  final int pre_cpu_stats_online_cpu;
  final int memory_usage;
  final int memory_max_usage;
  final int memory_limit;

  DockerContainerStats({
    this.num_procs,
    this.read,
    this.pidStats,
    this.now_cpu_stats_total_usage,
    this.now_cpu_stats_system_usage,
    this.now_cpu_stats_online_cpu,
    this.pre_cpu_stats_total_usage,
    this.pre_cpu_stats_system_usage,
    this.pre_cpu_stats_online_cpu,
    this.memory_usage,
    this.memory_max_usage,
    this.memory_limit,
  });

  double get cpuDelta =>
      (now_cpu_stats_total_usage - pre_cpu_stats_total_usage).toDouble();

  double get systemDelta =>
      (now_cpu_stats_system_usage - pre_cpu_stats_system_usage).toDouble();

  double get cpuPercent => (systemDelta > 0 && cpuDelta > 0)
      ? double.parse(
          ((cpuDelta / systemDelta) * now_cpu_stats_online_cpu * 100.0)
              .toStringAsPrecision(3))
      : 0;

  double get memoryPercent => double.parse(
      ((memory_usage / memory_limit) * 100).toStringAsPrecision(3));
}
