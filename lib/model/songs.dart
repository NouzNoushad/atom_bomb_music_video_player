import 'dart:io';

class Songs {
  final int id;
  final String name;
  final File? path;

  Songs({
    this.id = 0,
    this.name = '',
    this.path,
  });
}
