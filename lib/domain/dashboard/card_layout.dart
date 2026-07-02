class CardLayout {
  final int x, y, w, h;

  const CardLayout({
    required this.x,
    required this.y,
    required this.w,
    required this.h,
  });

  Map<String, dynamic> toJson() => {'x': x, 'y': y, 'w': w, 'h': h};

  factory CardLayout.fromJson(Map<String, dynamic> json) {
    return CardLayout(x: json['x'], y: json['y'], w: json['w'], h: json['h']);
  }
}
