import 'dart:convert';
import 'dart:io';

import 'package:rxdarttutorial/models/animal.dart';
import 'package:rxdarttutorial/models/person.dart';
import 'package:rxdarttutorial/models/things.dart';

typedef SearchTerm = String;

class Api {
  List<Animal>? _animals;

  List<Person>? _persons;

  Api();

  Future<List<Thing>> search(SearchTerm searchTerm) async {
    final term = searchTerm.trim().toLowerCase();

    final cachedResults = _extractThingsUsingSearchTerm(searchTerm);

    if (cachedResults != null) {
      return cachedResults;
    }

    final persons = await Future<List<Map<String, dynamic>>>.value([
      {"name": "Foo", "age": 20},
      {"name": "Bar", "age": 30},
      {"name": "Baz", "age": 40}
    ]).then((json) => json.map((e) => Person.fromJson(e)));

    _persons = persons.toList();

    final animals = await Future<List<Map<String, dynamic>>>.value([
      {"name": "Fluffers", "type": "cat"},
      {"name": "Woofson", "type": "dog"},
      {"name": "Bunz", "type": "rabbit"}
    ]).then((json) => json.map((e) => Animal.fromJson(e)));

    _animals = animals.toList();

    return _extractThingsUsingSearchTerm(searchTerm) ?? [];
  }

  Future<List<dynamic>> _getJson(String url) => HttpClient()
      .getUrl(Uri.parse(url))
      .then((value) => value.close())
      .then((response) => response.transform(utf8.decoder).join())
      .then((jsonString) => json.decode(jsonString) as List<dynamic>);

  List<Thing>? _extractThingsUsingSearchTerm(SearchTerm term) {
    final cachedAnimals = _animals;
    final cachedPersons = _persons;

    if (cachedAnimals != null && cachedPersons != null) {
      List<Thing> result = [];

      for (final animal in cachedAnimals) {
        if (animal.name.trimmedContains(term) ||
            animal.type.toString().trimmedContains(term)) {
          result.add(animal);
        }
      }

      for (final person in cachedPersons) {
        if (person.name.trimmedContains(term) ||
            person.age.toString().trimmedContains(term)) {
          result.add(person);
        }
      }

      return result;
    } else {
      return null;
    }
  }
}

extension TrimmedCaeInsensitiveContain on String {
  bool trimmedContains(String other) =>
      trim().toLowerCase().contains(other.trim().toLowerCase());
}
