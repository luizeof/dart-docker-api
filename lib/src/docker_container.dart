import 'docker_port.dart';
import 'docker_label.dart';
import 'docker_api_base.dart';

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
  List env = [];
  String workingDir;
  String entrypoint;
  String gatewayIpv4;
  String gatewayIpv6;
  String localIpv4;
  String localIpv6;
  String macAddress;
  List<DockerPort> _ports = [];
  List<DockerLabel> _labels = [];

  DockerContainer(
      {this.id,
      this.name,
      this.image,
      this.command,
      this.path,
      this.createdAt,
      this.stateStatus,
      List ports,
      List labels}) {
    this.id = id;
    if (ports != null) {
      ports.forEach((items) => _ports.add(DockerPort.fromJson(items)));
    }
    if (labels != null) {
      labels.forEach((items) => _labels.add(DockerLabel.fromJson(items)));
    }
  }

  static DockerContainer fromJson(json) {
    return new DockerContainer(
      id: json['Id'],
      name: json['Name'],
      image: json['Config']['Image'],
      command: json['Config']['Cmd'].toString(),
      path: json['Path'].toString(),
      createdAt: DateTime.parse(json["Created"]),
    );
  }
}
