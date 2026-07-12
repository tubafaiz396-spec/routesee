import 'dart:io';

void main() {
  final file = File('lib/data/campus_data.dart');
  final lines = file.readAsLinesSync();
  final idReg = RegExp(r"id:\s*'([^']+)' $");
}
