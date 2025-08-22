import 'package:arari_next/utils/Console_log/console_buffer.dart';

main () {
  int i = 0;
  final Buffer<int> testbuffer = Buffer(size: 100);
  while (i<= 150) {
    testbuffer.add(i);
    i++;
  }

  testbuffer.clear();

  print(testbuffer);
  
}