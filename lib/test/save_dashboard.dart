import 'package:arari_next/data/repositories/dashboard/dashboard_repository.dart';
import 'package:arari_next/data/repositories/dashboard/dashboard_repository_impl.dart';
import 'package:arari_next/data/services/file/local_file_storage_service.dart';
import 'package:arari_next/domain/dashboard/card_layout.dart';
import 'package:arari_next/domain/dashboard/card_type.dart';
import 'package:arari_next/domain/dashboard/dashboard_model.dart';
import 'package:arari_next/domain/dashboard/metric_card_model.dart';

void main() async {
  DashboardRepository repository = DashboardRepositoryImpl(
    fileStorageService: LocalFileStorageService(),
  );

  DashboardModel dashboard = DashboardModel(
    id: '1',
    name: 'Default 1',
    cards: [
      MetricCardModel(
        id: '1',
        type: CardType.metric,
        layout: CardLayout(x: 0, y: 0, w: 2, h: 2),
        selectedMetric: 'soc',
      ),
      MetricCardModel(
        id: '2',
        type: CardType.metric,
        layout: CardLayout(x: 3, y: 3, w: 2, h: 2),
        selectedMetric: 'batteryVoltage',
      ),
    ],
  );

  DashboardModel dashboard2 = DashboardModel(
    id: '2',
    name: 'Default 2',
    cards: [
      MetricCardModel(
        id: '1',
        type: CardType.metric,
        layout: CardLayout(x: 1, y: 3, w: 1, h: 1),
        selectedMetric: 'rpm',
      ),
      MetricCardModel(
        id: '2',
        type: CardType.metric,
        layout: CardLayout(x: 4, y: 4, w: 1, h: 2),
        selectedMetric: 'temperature',
      ),
    ],
  );

  repository.saveDashboard(dashboard);
  repository.saveDashboard(dashboard2);
}
