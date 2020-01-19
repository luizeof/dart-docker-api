import 'package:dio/dio.dart';
import 'dart:convert';

class DockerAPI {
  final String _hostname;
  final String _username;
  final String _password;
  String apiVersion;
  String version;
  String minAPIVersion;
  String operatingSystem;
  String goVersion;
  String platform;
  String platformArchitecture;
  String kernelVersion;
  String dockerRootDir;
  int numContainers;
  int numContainersRunning;
  int numContainersPaused;
  int numContainersStopped;
  int numImages;
  int cpuCores;
  int memoryTotal;
  Dio _dio;

  DockerAPI(this._hostname, [this._username, this._password]) {
    _dio = new Dio();
    _dio.options.baseUrl = _hostname;
    _dio.options.connectTimeout = 60000;
    _dio.options.receiveTimeout = 60000;
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$_username:$_password'));
    _dio.options.headers = (<String, String>{'authorization': basicAuth});
  }

  static Future<DockerAPI> connect(String _hostname,
      [String _username, String _password]) async {
    var api = new DockerAPI(_hostname, _username, _password);
    try {
      await api.getVersionData();
      await api.getInfoData();
      return api;
    } catch (e) {
      return null;
    }
  }

  String _getString(dynamic data, [dynamic _ifNull = null]) {
    return (data == null) ? _ifNull : data.toString();
  }

  int _getInt(dynamic data, [dynamic _ifNull = null]) {
    var parsed = (data == null) ? _ifNull : int.tryParse(data.toString());
    return (parsed == null) ? _ifNull : parsed;
  }

  Future<dynamic> getInfoData() async {
    var data = await _dio.get("/info");
    try {
      var json = jsonDecode(data.toString());
      numContainers = _getInt(json["Containers"], 0);
      numContainersRunning = _getInt(json["ContainersRunning"], 0);
      numContainersPaused = _getInt(json["ContainersPaused"], 0);
      numContainersStopped = _getInt(json["ContainersStopped"], 0);
      numImages = _getInt(json["Images"], 0);
      operatingSystem = _getString(json["OperatingSystem"]);
      dockerRootDir = _getString(json['DockerRootDir']);
      return json;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> getVersionData() async {
    var data = await _dio.get("/version");
    try {
      var json = jsonDecode(data.toString());
      version = _getString(json['Version']);
      apiVersion = _getString(json['ApiVersion']);
      minAPIVersion = _getString(json["MinAPIVersion"]);
      goVersion = _getString(json["GoVersion"]);
      platform = _getString(json['Os']);
      platformArchitecture = _getString(json['Arch']);
      kernelVersion = _getString(json['KernelVersion']);
      return json;
    } catch (e) {
      return null;
    }
  }
}
