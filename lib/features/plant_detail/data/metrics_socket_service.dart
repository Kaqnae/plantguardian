import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class MetricsSocketService {
  static final MetricsSocketService _instance =
      MetricsSocketService._internal();
  factory MetricsSocketService() => _instance;
  MetricsSocketService._internal();

  IO.Socket? _socket;

  static Future<void> saveLatestMetric(
    String plantID,
    Map<String, dynamic> metric,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('metric_$plantID', jsonEncode(metric));
  }

  static Future<Map<String, dynamic>?> loadLatestMetric(String plantID) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('metric_$plantID');
    if (jsonString != null) {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    }
    return null;
  }

  void connect({
    required String url,
    required String roomId,
    required void Function(dynamic data) onMetricNewData,
    void Function(dynamic error)? onError,
    void Function(dynamic data)? onSuccess,
  }) {
    if (_socket != null) {
      _socket!.disconnect();
      _socket!.destroy();
      _socket!.clearListeners();
      _socket = null;
    }

    _socket = IO.io(url, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket!.connect();

    _socket!.off('connect');
    _socket!.off('metric_new_data');
    _socket!.off('metric_error');
    _socket!.off('metric_success');
    _socket!.off('disconnect');

    _socket!.onConnect((_) {
      if (_socket != null) {
        _socket!.emit('join_room', roomId.toString());
      }
    });

    _socket!.on('metric_new_data', (data) async {
      if (data is String) {
        data = jsonDecode(data);
      }
      await saveLatestMetric(roomId, data);
      onMetricNewData(data);
    });

    if (onError != null) {
      _socket!.on('metric_error', onError);
    }
    if (onSuccess != null) {
      _socket!.on('metric_success', onSuccess);
    }

    _socket!.onDisconnect((_) {});
  }

  void disconnect() {
    if (_socket != null) {
      _socket?.disconnect();
      _socket?.destroy();
      _socket = null;
    }
  }
}
