class DockerNetworkBridge {
  String networkID;
  String endpointID;
  String gateway;
  String ipAddress;
  int ipPrefixLen;
  String ipV6Gateway;
  String macAddress;

  DockerNetworkBridge({
    this.networkID = "",
    this.endpointID = "",
    this.gateway = "",
    this.ipAddress = "",
    this.ipPrefixLen = 0,
    this.ipV6Gateway = "",
    this.macAddress = "",
  });

  static DockerNetworkBridge fromJson(js) {
    return DockerNetworkBridge(
      networkID: js['NetworkID'],
      endpointID: js['EndpointID'],
      gateway: js['Gateway'],
      ipAddress: js['IPAddress'],
      ipPrefixLen: js['IPPrefixLen'],
      ipV6Gateway: js['IPv6Gateway'],
      macAddress: js['MacAddress'],
    );
  }
}
