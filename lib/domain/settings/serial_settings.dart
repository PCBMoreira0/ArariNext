class SerialSettings {
  final String port;
  final int baudrate;

  SerialSettings({
    required this.port,
    required this.baudrate,
  });

  factory SerialSettings.fromJson(Map<String, dynamic> json) {
    return SerialSettings(
      port: json['port'],
      baudrate: json['baudrate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'port': port,
      'baudrate': baudrate,
    };
  }
}