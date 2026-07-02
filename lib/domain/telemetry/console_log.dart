// criando datatype console log.

enum LogType {
    error,
    warning,
    info,
    input
  }

final class ConsoleLog {

  final LogType type;
  final DateTime datetime;
  final String contents;

  ConsoleLog({required this.type, required this.datetime, required this.contents});
}