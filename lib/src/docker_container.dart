import 'package:docker_api/src/docker_env.dart';
import 'docker_mount.dart';
import 'docker_port.dart';

/// Docker Container
class DockerContainer {
  ///
  String id;
  String name;
  String image;
  String command;
  String path;
  String stateStatus;
  String lastError;
  String hostname;
  String user;
  String workingDir;
  String entrypoint;
  String gatewayIpv4;
  String localIpv4;
  String macAddress;

  DateTime createdAt;
  DateTime startedAt;
  DateTime finishedAt;

  int pid = 0;
  int exitCode = 0;
  int restartCount = 0;

  bool autoRemove = false;
  bool privileged = false;
  bool publishAllPorts = false;
  bool attachStdin = false;
  bool attachStdout = false;
  bool attachStderr = false;
  bool tty = false;
  bool isRunning = false;
  bool isPaused = false;
  bool isRestarting = false;
  bool isDead = false;

  double cpuShares = 0;
  double memoryLimit = 0;
  double cpuPeriod = 0;
  double cpuQuota = 0;

  dynamic args = [];

  List<DockerEnv> env = [];
  List<DockerPort> ports = [];
  List<DockerMount> mounts = [];

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
    dynamic ports,
    dynamic args,
    dynamic mounts,
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
    this.args = args.toList();

    // Map Envs
    for (int i = 0; i <= env.length - 1; i++) {
      var e = env[i].toString().split('=');
      this.env.add(new DockerEnv(e[0].toString(), e[1].toString()));
    }

    // Map Container Mounts
    for (int i = 0; i <= mounts.length - 1; i++) {
      this.mounts.add(DockerMount.fromJson(mounts[i]));
    }

    // Map Container Ports
    ports.forEach((key, value) {
      var items = value.toList();
      for (int i = 0; i <= value.length - 1; i++) {
        this.ports.add(
              new DockerPort(key, items[i]['HostPort'], items[i]['HostIp']),
            );
      }
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
      ports: json['NetworkSettings']['Ports'],
      args: json['Args'],
      mounts: json['Mounts'],
    );
  }
}
