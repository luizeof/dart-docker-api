library docker_api;

import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:docker_api/src/docker_container.dart';
import 'package:docker_api/src/docker_container_resume.dart';
import 'package:docker_api/src/docker_stats.dart';

/// Docker API
class DockerAPI {
  final String _hostname;
  double _imagesDiskUsage = 0;
  double _containersDiskUsage = 0;
  double _volumesDiskUsage = 0;

  /// Docker API Version
  String apiVersion;

  /// Docker Version
  String engineVersion;

  // Minimal compatible version
  String minAPIVersion;

  /// Server Operating Systema
  String operatingSystem;

  /// Server Operating System Platform
  String platform;

  /// Server Architecture
  String platformArchitecture;

  /// Kernel Version
  String kernelVersion;

  /// Docker Root Directory on Server
  String dockerRootDir;

  /// Number of Created Containers
  int numContainers;

  /// Number of Containers Running
  int numContainersRunning;

  /// Number of Containers Paused
  int numContainersPaused;

  /// Number of Containers Stopped
  int numContainersStopped;

  /// Number of Pulled Images
  int numImages;

  /// Amount of Server CPU Cores
  int cpuCores;

  /// Amount of Server Memory
  int memoryTotal;

  /// Images Space Usage in Bytes
  double get imagesDiskUsageBytes => _imagesDiskUsage;

  /// Images Space Usage in KiloBytes
  double get imagesDiskUsageKB => _roundBytes(imagesDiskUsageBytes / 1000);

  /// Images Space Usage in MegaBytes
  double get imagesDiskUsageMB => _roundBytes(imagesDiskUsageKB / 1000);

  /// Images Space Usage in GigaBytes
  double get imagesDiskUsageGB => _roundBytes(imagesDiskUsageMB / 1000);

  /// Containers Space Usage in Bytes
  double get containersDiskUsageBytes => _containersDiskUsage;

  /// Containers Space Usage in KiloBytes
  double get containersDiskUsageKB =>
      _roundBytes(containersDiskUsageBytes / 1000);

  /// Containers Space Usage in MegaBytes
  double get containersDiskUsageMB => _roundBytes(containersDiskUsageKB / 1000);

  /// Containers Space Usage in GigaBytes
  double get containersDiskUsageGB => _roundBytes(containersDiskUsageMB / 1000);

  /// Volumes Space Usage in Bytes
  double get volumesDiskUsageBytes => _volumesDiskUsage;

  /// Volumes Space Usage in KiloBytes
  double get volumesDiskUsageKB => _roundBytes(volumesDiskUsageBytes / 1000);

  /// Volumes Space Usage in MegaBytes
  double get volumesDiskUsageMB => _roundBytes(volumesDiskUsageKB / 1000);

  /// Volumes Space Usage in GigaBytes
  double get volumesDiskUsageGB => _roundBytes(volumesDiskUsageMB / 1000);

  // HTTP Wrapper
  Dio _dio;

  DockerAPI(this._hostname,
      {basicAuthUsername, basicAuthPassword, useBasicAuth = false}) {
    _dio = new Dio();
    _dio.options.baseUrl = _hostname;
    _dio.options.connectTimeout = 60000;
    _dio.options.receiveTimeout = 60000;
    if (useBasicAuth) {
      String basicAuth = 'Basic ' +
          base64Encode(utf8.encode('$basicAuthUsername:$basicAuthPassword'));
      _dio.options.headers = (<String, String>{'authorization': basicAuth});
    }
  }

  /// Return a new instance of Remote Docker API with HTTP Basic Auth
  static Future<DockerAPI> connectRemoteWithBasicAuth(
      String _hostname, String _username, String _password) async {
    var api = new DockerAPI(_hostname,
        basicAuthUsername: _username,
        basicAuthPassword: _password,
        useBasicAuth: true);
    try {
      await api._getVersionData();
      await api._getInfoData();
      await api._getUsage();
      return api;
    } catch (e) {
      return null;
    }
  }

  /// Return a new instance of Remote Docker API without Auth
  static Future<DockerAPI> connectRemote(String _hostname) async {
    var api = new DockerAPI(_hostname, useBasicAuth: false);
    try {
      await api._getVersionData();
      await api._getInfoData();
      await api._getUsage();
      return api;
    } catch (e) {
      return null;
    }
  }

  /// Parse [data] and Return ```String```
  String _getString(dynamic data, [dynamic _ifNull = null]) {
    return (data == null) ? _ifNull : data.toString();
  }

  /// Parse [data] and return ```Int```
  int _getInt(dynamic data, [dynamic _ifNull = null]) {
    var parsed = (data == null) ? _ifNull : int.tryParse(data.toString());
    return (parsed == null) ? _ifNull : parsed;
  }

  /// Round double value to precision 3
  double _roundBytes(double _value) {
    return double.tryParse(_value.toStringAsPrecision(3));
  }

  /// Load Docker Info Data
  void _getInfoData() async {
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
      cpuCores = _getInt(json['NCPU']);
      memoryTotal = _getInt(json['MemTotal']);
      return json;
    } catch (e) {}
  }

  /// Load Docker Version Data
  void _getVersionData() async {
    var data = await _dio.get("/version");
    try {
      var json = jsonDecode(data.toString());
      engineVersion = _getString(json['Version']);
      apiVersion = _getString(json['ApiVersion']);
      minAPIVersion = _getString(json["MinAPIVersion"]);
      platform = _getString(json['Os']);
      platformArchitecture = _getString(json['Arch']);
      kernelVersion = _getString(json['KernelVersion']);
      return json;
    } catch (e) {}
  }

  /// Load Docker Usage Data
  void _getUsage() async {
    var data = await _dio.get("/system/df");
    try {
      var json = jsonDecode(data.toString());
      json['Images'].forEach((e) => _imagesDiskUsage += e['Size']);
      json['Containers']
          .forEach((e) => _containersDiskUsage += e['SizeRootFs']);
      json['Volumes']
          .forEach((e) => _volumesDiskUsage += e['UsageData']["Size"]);
    } catch (e) {}
  }

  Future<DockerContainer> getContainerByID(String _hashid) async {
    var data = await _dio.get('/containers/$_hashid/json');
    try {
      var json = jsonDecode(data.toString());
      return DockerContainer.fromJson(json.trim);
    } catch (e) {
      return null;
    }
  }

  Future<List<DockerContainerResume>> getContainers() async {
    var _list = List<DockerContainerResume>();
    var data = await _dio.get('/containers/json?all=true');
    var json = jsonDecode(data.toString());
    for (int i = 0; i <= json.length - 1; i++) {
      _list.add(DockerContainerResume.fromJson(json[i]));
    }
    return _list;
  }

  Future<DockerContainerStats> getContainerStats(String _hashid) async {
    var data = await _dio.get('/containers/$_hashid/stats?stream=false');
    try {
      var json = jsonDecode(data.toString());
      return DockerContainerStats(
        read: DateTime.tryParse(json['read']),
        pidStats: json['pids_stats']['current'],
        num_procs: json['num_procs'],
        now_cpu_stats_total_usage: json['cpu_stats']['cpu_usage']
            ['total_usage'],
        now_cpu_stats_system_usage: json['cpu_stats']['system_cpu_usage'],
        now_cpu_stats_online_cpu: json['cpu_stats']['online_cpus'],
        pre_cpu_stats_total_usage: json['precpu_stats']['cpu_usage']
            ['total_usage'],
        pre_cpu_stats_system_usage: json['precpu_stats']['system_cpu_usage'],
        pre_cpu_stats_online_cpu: json['precpu_stats']['online_cpus'],
        memory_limit: json['memory_stats']['limit'],
        memory_max_usage: json['memory_stats']['max_usage'],
        memory_usage: json['memory_stats']['usage'],
      );
    } catch (e) {
      return null;
    }
  }
}
