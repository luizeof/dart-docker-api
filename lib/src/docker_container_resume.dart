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
  String get shortname => id.substring(1, 12);

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
    this.createdAt,
  );

  ///
  static DockerContainerResume fromJson(json) {
    return DockerContainerResume(
      json['Id'],
      json['Name'],
      json['Image'],
      json['State'],
      json['Status'],
      DateTime.parse(json['Created']),
    );
  }
}
