import 'package:flutter/foundation.dart';
import 'package:rxdarttutorial/models/things.dart';

@immutable
class Person extends Thing {
  final int age;
  const Person({required this.age, required String name}) : super(name: name);

  Person.fromJson(Map<String, dynamic> json)
      : age = json['age'] as int,
        super(name: json['name']);
}
