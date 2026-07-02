import 'package:arari_next/data/repositories/dashboard/dashboard_repository.dart';
import 'package:arari_next/data/repositories/dashboard/dashboard_repository_impl.dart';
import 'package:arari_next/data/services/file/local_file_storage_service.dart';
import 'package:arari_next/domain/dashboard/dashboard_model.dart';

void main() async {
  DashboardRepository repository = DashboardRepositoryImpl(
    fileStorageService: LocalFileStorageService(),
  );

  List<DashboardModel> dashboards = await repository.loadDashboards();

  print('Loaded dashboards:');
  for (var dashboard in dashboards) {
    print('ID: ${dashboard.id}, Name: ${dashboard.name}');
  }
}
