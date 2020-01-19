import 'package:docker_api/docker_api.dart';

void main() async {
  var api = await DockerAPI.connect('http://server:8099/', 'user', 'password');

  print(api.kernelVersion);
  print(api.imagesDiskUsageBytes);
  print(api.imagesDiskUsageKB);
  print(api.imagesDiskUsageMB);
  print(api.imagesDiskUsageGB);
  print(api.containersDiskUsageBytes);
  print(api.containersDiskUsageKB);
  print(api.containersDiskUsageMB);
  print(api.containersDiskUsageGB);
  print(api.volumesDiskUsageBytes);
  print(api.volumesDiskUsageKB);
  print(api.volumesDiskUsageMB);
  print(api.volumesDiskUsageGB);
}
