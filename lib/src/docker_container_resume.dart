class DockerContainerResume {
  ///
  String id;

  ///
  String name;

  ///
  String image;

  ///
  String state;

  ///
  String status;

  ///
  DateTime createdAt;

  ///
  String get shortname => id.substring(0, 11);

  ///
  bool get isRunning => (state == 'running');

  ///
  bool get isPaused => (state == 'paused');

  ///
  bool get isStopped => (state == 'stopped');

  ///
  DockerContainerResume(
    this.id,
    this.name,
    this.image,
    this.state,
    this.status,
  );

  ///
  static DockerContainerResume fromJson(json) {
    return DockerContainerResume(
      json['Id'].toString(),
      json['Names'][0].toString().replaceAll('/', ''),
      json['Image'].toString(),
      json['State'].toString(),
      json['Status'].toString(),
    );
  }
}
