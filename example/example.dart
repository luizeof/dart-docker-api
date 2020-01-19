import 'package:docker_api/docker_api.dart';

void main() async {
  var api = await DockerAPI.connect('http://server:8099/', 'user', 'password');

  print(api.kernelVersion);
}
