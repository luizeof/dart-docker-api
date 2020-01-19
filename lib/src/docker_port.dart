/// Docker Port
class DockerPort {
  /// IP Address
  final String ip;

  /// Private Port
  final int privatePort;

  /// Public Port
  final int publicPort;

  /// Port Type
  final String type;

  /// Constructor
  DockerPort(this.ip, this.privatePort, this.publicPort, this.type);

  /// Return DockerPort from Json Data
  static DockerPort fromJson(js) {
    return DockerPort(
      js['ip'],
      js['privatePort'],
      js['publicPort'],
      js['type'],
    );
  }
}
