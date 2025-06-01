import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

/// Service class for managing the metrics socket connection and caching the latest metric.
class MetricsSocketService {
  // Singleton instance
  static final MetricsSocketService _instance =
      MetricsSocketService._internal();
  factory MetricsSocketService() => _instance;
  MetricsSocketService._internal();

  IO.Socket? _socket;

  /// Saves the latest metric for a plant in shared preferences.
  static Future<void> saveLatestMetric(
    String plantID,
    Map<String, dynamic> metric,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('metric_$plantID', jsonEncode(metric));
  }

  /// Loads the latest cached metric for a plant from shared preferences.
  static Future<Map<String, dynamic>?> loadLatestMetric(String plantID) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('metric_$plantID');
    if (jsonString != null) {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    }
    return null;
  }

  /// Connects to the metrics socket server with the given URL and room ID.
  /// Listens for new metric data and caches it.
  /// Accepts callbacks for new data, errors, and success events.
  void connect({
    required String url,
    required String roomId,
    required void Function(dynamic data) onMetricNewData,
    void Function(dynamic error)? onError,
    void Function(dynamic data)? onSuccess,
  }) {
    // Disconnect and clean up any existing socket connection.
    if (_socket != null) {
      _socket!.disconnect();
      _socket!.destroy();
      _socket!.clearListeners();
      _socket = null;
    }

    // Initialize the socket connection.
    _socket = IO.io(url, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket!.connect();

    // Remove any previous listeners to avoid duplicates.
    _socket!.off('connect');
    _socket!.off('metric_new_data');
    _socket!.off('metric_error');
    _socket!.off('metric_success');
    _socket!.off('disconnect');

    // Join the specified room when connected.
    _socket!.onConnect((_) {
      if (_socket != null) {
        _socket!.emit('join_room', roomId.toString());
      }
    });

    // Listen for new metric data, cache it, and call the provided callback.
    _socket!.on('metric_new_data', (data) async {
      if (data is String) {
        data = jsonDecode(data);
      }
      await saveLatestMetric(roomId, data);
      onMetricNewData(data);
    });

    // Listen for error and success events if callbacks are provided.
    if (onError != null) {
      _socket!.on('metric_error', onError);
    }
    if (onSuccess != null) {
      _socket!.on('metric_success', onSuccess);
    }

    // Handle socket disconnect event (currently does nothing).
    _socket!.onDisconnect((_) {});
  }

  /// Disconnects and cleans up the socket connection.
  void disconnect() {
    if (_socket != null) {
      _socket?.disconnect();
      _socket?.destroy();
      _socket = null;
    }
  }
}
