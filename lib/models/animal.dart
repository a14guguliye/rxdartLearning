import 'package:flutter/foundation.dart';
import 'package:rxdarttutorial/models/things.dart';

enum AnimalType { dog, cat, rabbit, unknown }

@immutable
class Animal extends Thing {
  final AnimalType type;

  const Animal({required this.type, required String name}) : super(name: name);

  @override
  String toString() {
    return "Animal, name: $name, type: $type";
  }

  factory Animal.fromJson(Map<String, dynamic> json) {
    final AnimalType animalType;

    switch (json["type"]) {
      case "rabbit":
        animalType = AnimalType.rabbit;
        break;
      case "dog":
        animalType = AnimalType.dog;
        break;
      case "cat":
        animalType = AnimalType.cat;
        break;
      default:
        animalType = AnimalType.unknown;
        break;
    }

    return Animal(type: animalType, name: json['name']);
  }
}
