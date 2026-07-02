enum CardType {
  propulsion('propulsion'),
  battery('battery'),
  metric('metric');

  const CardType(this.jsonValue);

  final String jsonValue;

  static CardType fromJson(String value) {
    return CardType.values.firstWhere((e) => e.jsonValue == value);
  }
}
