/// Docker Mount
class DockerMount {
  /// Mount Type: `bind` or `volume`
  final String type;

  /// Mount Name
  final String name;

  /// Mount Source Path
  final String source;

  /// Mount Destination Path
  final String destination;

  /// Mount Driver
  final String driver;

  /// Mount Mode
  final String mode;

  /// Mount Read/Write?
  final bool rw;

  /// Mount Propagation
  final String propagation;

  DockerMount({
    this.type,
    this.name,
    this.destination,
    this.driver,
    this.mode,
    this.propagation,
    this.rw,
    this.source,
  });

  static DockerMount fromJson(json) {
    return DockerMount(
      name: (json['Type'] == 'bind') ? json['Source'] : json['Name'],
      type: json['Type'],
      destination: json['Destination'],
      driver: (json['Type'] == 'bind') ? 'none' : json['Driver'],
      mode: json['Mode'],
      propagation: json['Propagation'],
      rw: json['RW'],
      source: json['Source'],
    );
  }
}
