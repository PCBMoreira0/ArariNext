import 'package:arari_next/domain/dashboard/card_model.dart';

class DashboardModel {
  final String id;
  final String name;
  final List<CardModel> cards;

  DashboardModel({required this.id, required this.name, required this.cards});

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'cards': cards.map((e) => e.toJson()).toList(),
  };

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      id: json['id'],
      name: json['name'],
      cards: (json['cards'] as List).map((e) => CardModel.fromJson(e)).toList(),
    );
  }
}
