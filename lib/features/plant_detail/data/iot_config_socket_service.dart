import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:plantguardian/features/plant_detail/domain/iot_config_model.dart';

class IotConfigSocketService {
  static final IotConfigSocketService _instance =
      IotConfigSocketService._internal();
  factory IotConfigSocketService() => _instance;
  IotConfigSocketService._internal();

  IO.Socket? _socket;

  void connect({
    required String url,
    required String roomId,

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
    _socket!.off('iot_config_update');
    _socket!.off('iot_config_error');
    _socket!.off('iot_config_success');
    _socket!.off('disconnect');

    _socket!.onConnect((_) {
      if (_socket != null) {
        _socket!.emit('join_room', roomId.toString());
      }
    });

    _socket!.on('iot_config_update', (data) {});

    if (onError != null) {
      _socket!.on('iot_config_error', onError);
    }
    if (onSuccess != null) {
      _socket!.on('iot_config_success', onSuccess);
    }

    _socket!.onDisconnect((_) {});
  }

  void disconnect() {
    if (_socket != null) {
      _socket!.disconnect();
      _socket!.destroy();
      _socket = null;
    }
  }

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
