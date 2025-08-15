// criando datatype console log.

enum ErrorType {
    error,
    warning,
    info,
  }

final class ConsoleLog {

  final ErrorType type;
  final DateTime datetime;
  final String contents;

  ConsoleLog({required this.type, required this.datetime, required this.contents});
}