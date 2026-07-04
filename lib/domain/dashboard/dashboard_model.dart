import 'package:arari_next/domain/dashboard/card_model.dart';
import 'package:sliver_dashboard/sliver_dashboard.dart';

class DashboardModel {
  final String id;
  final String name;
  final Map<int, List<LayoutItem>> layouts;
  final List<CardModel> cards;

  DashboardModel({
    required this.id,
    required this.name,
    required this.layouts,
    required this.cards,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'layouts': layouts.map(
      (slotCount, items) => MapEntry(
        slotCount.toString(),
        items.map((item) => item.toMap()).toList(),
      ),
    ),
    'cards': cards.map((e) => e.toJson()).toList(),
  };

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    final layoutsJson = json['layouts'] as Map<String, dynamic>? ?? {};

    return DashboardModel(
      id: json['id'],
      name: json['name'],
      layouts: layoutsJson.map(
        (slotCountStr, itemsList) => MapEntry(
          int.parse(slotCountStr),
          (itemsList as List).map((e) => LayoutItem.fromMap(e)).toList(),
        ),
      ),
      cards: (json['cards'] as List).map((e) => CardModel.fromJson(e)).toList(),
    );
  }

  factory DashboardModel.empty(String id) {
    return DashboardModel(id: id, name: 'My Dashboard', layouts: {}, cards: []);
  }

  DashboardModel copyWith({
    String? id,
    String? name,
    Map<int, List<LayoutItem>>? layouts,
    List<CardModel>? cards,
  }) {
    return DashboardModel(
      id: id ?? this.id,
      name: name ?? this.name,
      layouts: layouts ?? this.layouts,
      cards: cards ?? this.cards,
    );
  }
}
