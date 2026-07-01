class MqttSettings {
  final String address;
  final int port;

  MqttSettings({
    required this.address,
    required this.port,
  });

  factory MqttSettings.fromJson(Map<String, dynamic> json) {
    return MqttSettings(
      address: json['address'],
      port: json['port'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'port': port,
    };
  }
}