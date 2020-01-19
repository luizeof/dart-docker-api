import 'docker_port.dart';
import 'docker_label.dart';

/// Docker Container
class DockerContainer {
  final String id;
  final String name;
  final String image;
  final String command;
  final DateTime created;
  final String state;
  final String status;
  List<DockerPort> ports = [];
  List<DockerLabel> labels = [];

  DockerContainer(
    this.id,
    this.name,
    this.image,
    this.command,
    this.created,
    this.state,
    this.status, [
    List _ports,
    List _labels,
  ]) {
    if (_ports.isNotEmpty) {
      _ports.forEach((js) => ports.add(DockerPort.fromJson(js)));
      _labels.forEach((kv) => labels.add(DockerLabel.fromJson(kv)));
    }
  }
}
