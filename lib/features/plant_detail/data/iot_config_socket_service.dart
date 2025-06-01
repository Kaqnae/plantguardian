import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:plantguardian/features/plant_detail/domain/iot_config_model.dart';

/// Service class for managing the IoT config socket connection.
class IotConfigSocketService {
  // Singleton instance
  static final IotConfigSocketService _instance =
      IotConfigSocketService._internal();
  factory IotConfigSocketService() => _instance;
  IotConfigSocketService._internal();

  IO.Socket? _socket;

  /// Connects to the socket server with the given URL and room ID.
  /// Optionally accepts error and success callbacks.
  void connect({
    required String url,
    required String roomId,
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
    _socket!.off('iot_config_update');
    _socket!.off('iot_config_error');
    _socket!.off('iot_config_success');
    _socket!.off('disconnect');

    // Join the specified room when connected.
    _socket!.onConnect((_) {
      if (_socket != null) {
        _socket!.emit('join_room', roomId.toString());
      }
    });

    // Listen for IoT config updates (currently does nothing).
    _socket!.on('iot_config_update', (data) {});

    // Listen for error and success events if callbacks are provided.
    if (onError != null) {
      _socket!.on('iot_config_error', onError);
    }
    if (onSuccess != null) {
      _socket!.on('iot_config_success', onSuccess);
    }

    // Handle socket disconnect event (currently does nothing).
    _socket!.onDisconnect((_) {});
  }

  /// Disconnects and cleans up the socket connection.
  void disconnect() {
    if (_socket != null) {
      _socket!.disconnect();
      _socket!.destroy();
      _socket = null;
    }
  }

  /// Sends an IoT config update to the server for the current room.
  /// Throws an exception if the socket is not connected.
  void sendIotConfigUpdate(IotConfigModel iotConfig) {
    if (_socket != null && _socket!.connected) {
      final payload = {
        'roomId': iotConfig.customPlantId,
        'entity': iotConfig.toJson(),
      };
      _socket!.emit('send_iot_config', payload);
    } else {
      throw Exception('Socket is not connected');
    }
  }
}
