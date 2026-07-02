class SerialSettings {
  final String port;
  final int baudrate;

  const SerialSettings({this.port = '', this.baudrate = 115200});

  factory SerialSettings.fromJson(Map<String, dynamic> json) {
    return SerialSettings(port: json['port'], baudrate: json['baudrate']);
  }

  Map<String, dynamic> toJson() {
    return {'port': port, 'baudrate': baudrate};
  }

  SerialSettings copyWith({String? port, int? baudrate}) {
    return SerialSettings(
      port: port ?? this.port,
      baudrate: baudrate ?? this.baudrate,
    );
  }
}
