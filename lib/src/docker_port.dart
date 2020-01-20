/// Docker Port Mapping
class DockerPort {
  /// Port Name
  final String name;

  /// Port Allocated
  final String port;

  /// Internal IP
  final String ip;

  /// Port Protocol
  String get protocol =>
      (name.split('/').length == 2) ? name.split('/').last : '';

  DockerPort(this.name, this.port, this.ip);
}
