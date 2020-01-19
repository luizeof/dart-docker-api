/// Docker Label
class DockerLabel {
  /// Label Name
  final String name;

  /// Label Value
  final String value;

  /// Constructor
  DockerLabel(this.name, this.value);

  /// Return DockeDockerLabelrPort from Json Data
  static DockerLabel fromJson(js) {
    return DockerLabel(
      js[0],
      js[1],
    );
  }
}
