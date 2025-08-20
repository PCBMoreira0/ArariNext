// criando datatype console log.

enum DataType {
    error,
    warning,
    info,
  }

final class ConsoleLog {

  final DataType type;
  final DateTime datetime;
  final String contents;

  ConsoleLog({required this.type, required this.datetime, required this.contents});
}