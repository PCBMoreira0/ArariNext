enum ConnectionStatus {
  disconnected,
  connecting,
  reconnecting,
  connected,
  error,
}

enum ConnectionType {
  serial,
  mqtt
}

class ConnectionEvent {
  final ConnectionType type;
  final ConnectionStatus status;
  final String? message;

  ConnectionEvent(this.type, this.status, [this.message]);
}