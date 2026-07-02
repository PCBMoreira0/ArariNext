class MqttSettings {
  final String address;
  final int port;

  const MqttSettings({this.address = 'localhost', this.port = 1883});

  factory MqttSettings.fromJson(Map<String, dynamic> json) {
    return MqttSettings(address: json['address'], port: json['port']);
  }

  Map<String, dynamic> toJson() {
    return {'address': address, 'port': port};
  }

  MqttSettings copyWith({String? address, int? port}) {
    return MqttSettings(
      address: address ?? this.address,
      port: port ?? this.port,
    );
  }
}
