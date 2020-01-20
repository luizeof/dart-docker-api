/// Docker Container
class DockerContainer {
  String id;
  String name;
  String image;
  String command;
  String path;
  DateTime createdAt;
  DateTime startedAt;
  DateTime finishedAt;
  String stateStatus;
  bool isRunning = false;
  bool isPaused = false;
  bool isRestarting = false;
  bool isDead = false;
  int pid = 0;
  int exitCode = 0;
  String lastError;
  int restartCount = 0;
  bool autoRemove = false;
  bool privileged = false;
  bool publishAllPorts = false;
  double cpuShares = 0;
  double memoryLimit = 0;
  double cpuPeriod = 0;
  double cpuQuota = 0;
  String hostname;
  String user;
  bool attachStdin = false;
  bool attachStdout = false;
  bool attachStderr = false;
  bool tty = false;
  dynamic env = [];
  dynamic binds = [];
  List ports = [];
  dynamic args = [];
  String workingDir;
  String entrypoint;
  String gatewayIpv4;
  String localIpv4;
  String macAddress;

  DockerContainer({
    this.id,
    this.name,
    this.image,
    this.command,
    this.path,
    this.createdAt,
    this.stateStatus,
    this.isRunning,
    this.isDead,
    this.isPaused,
    this.isRestarting,
    this.pid,
    this.exitCode,
    this.attachStderr,
    this.attachStdin,
    this.attachStdout,
    this.autoRemove,
    this.cpuPeriod,
    this.cpuQuota,
    this.cpuShares,
    this.entrypoint,
    dynamic env,
    dynamic binds,
    dynamic ports,
    dynamic args,
    this.finishedAt,
    this.gatewayIpv4,
    this.hostname,
    this.lastError,
    this.localIpv4,
    this.macAddress,
    this.memoryLimit,
    this.privileged,
    this.publishAllPorts,
    this.restartCount,
    this.startedAt,
    this.tty,
    this.user,
    this.workingDir,
  }) {
    this.env = env.toList();
    this.binds = binds.toList();
    this.args = args.toList();
    ports.forEach((key, value) {
      this.ports.add([key, value]);
    });
  }

  static DockerContainer fromJson(json) {
    return new DockerContainer(
      id: json['Id'].toString(),
      name: json['Name'].toString(),
      image: json['Config']['Image'].toString(),
      command: json['Config']['Cmd'].toString(),
      path: json['Path'].toString(),
      createdAt: DateTime.parse(json["Created"]),
      startedAt: DateTime.parse(json['State']["StartedAt"]),
      finishedAt: DateTime.parse(json['State']["FinishedAt"]),
      stateStatus: json['State']['Status'].toString(),
      isRunning: json['State']['Running'],
      isPaused: json['State']['Paused'],
      isRestarting: json['State']['Restarting'],
      isDead: json['State']['Dead'],
      pid: json['State']['Pid'],
      exitCode: json['State']['ExitCode'],
      lastError: json['State']['Error'].toString(),
      restartCount: json['RestartCount'],
      autoRemove: json['HostConfig']['AutoRemove'],
      privileged: json['HostConfig']['Privileged'],
      publishAllPorts: json['HostConfig']['PublishAllPorts'],
      cpuShares: double.tryParse(json['HostConfig']['CpuShares'].toString()),
      memoryLimit: double.tryParse(json['HostConfig']['Memory'].toString()),
      cpuPeriod: double.tryParse(json['HostConfig']['CpuPeriod'].toString()),
      cpuQuota: double.tryParse(json['HostConfig']['CpuQuota'].toString()),
      hostname: json['Config']['Hostname'],
      user: json['Config']['User'],
      attachStdin: json['Config']['AttachStdin'],
      attachStdout: json['Config']['AttachStdout'],
      attachStderr: json['Config']['AttachStderr'],
      tty: json['Config']['Tty'],
      workingDir: json['Config']['WorkingDir'].toString(),
      entrypoint: json['Config']['Entrypoint'].toString(),
      gatewayIpv4: json['NetworkSettings']['Gateway'].toString(),
      localIpv4: json['NetworkSettings']['IPAddress'].toString(),
      macAddress: json['NetworkSettings']['MacAddress'].toString(),
      env: json['Config']['Env'],
      binds: (json['HostConfig']['Binds']),
      ports: json['NetworkSettings']['Ports'],
      args: json['Args'],
    );
  }
}
