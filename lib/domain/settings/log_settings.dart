class LogSettings {
  final String directory;

  const LogSettings({this.directory = '/logs'});

  factory LogSettings.fromJson(Map<String, dynamic> json) {
    return LogSettings(directory: json['directory']);
  }

  Map<String, dynamic> toJson() {
    return {'directory': directory};
  }

  LogSettings copyWith({String? directory}) {
    return LogSettings(directory: directory ?? this.directory);
  }
}
