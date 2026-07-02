abstract class FileStorageService {
  Future<String?> read(String fileName);

  Future<void> write(String fileName, String content);

  Future<bool> exists(String fileName);

  Future<void> delete(String fileName);
}
