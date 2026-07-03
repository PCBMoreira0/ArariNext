import 'package:arari_next/domain/dashboard/card_model.dart';
import 'package:sliver_dashboard/sliver_dashboard.dart';

class DashboardModel {
  final String id;
  final String name;
  final List<LayoutItem> layout;
  final List<CardModel> cards;

  DashboardModel({
    required this.id,
    required this.name,
    required this.layout,
    required this.cards,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'layout': layout.map((layout) => layout.toMap()).toList(),
    'cards': cards.map((e) => e.toJson()).toList(),
  };

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      id: json['id'],
      name: json['name'],
      layout: (json['layout'] as List)
          .map((e) => LayoutItem.fromMap(e))
          .toList(),
      cards: (json['cards'] as List).map((e) => CardModel.fromJson(e)).toList(),
    );
  }

  factory DashboardModel.empty(String id) {
    return DashboardModel(id: id, name: 'My Dashboard', layout: [], cards: []);
  }

  DashboardModel copyWith({
    String? id,
    String? name,
    List<LayoutItem>? layout,
    List<CardModel>? cards,
  }) {
    return DashboardModel(
      id: id ?? this.id,
      name: name ?? this.name,
      layout: layout ?? this.layout,
      cards: cards ?? this.cards,
    );
  }
}
