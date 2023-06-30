import 'package:flutter/foundation.dart' show immutable;
import 'package:rxdarttutorial/models/things.dart';

@immutable
abstract class SearchResult {
  const SearchResult();
}

@immutable
class SearchResultLoading implements SearchResult {}

@immutable
class SearchResultNoResult implements SearchResult {}

@immutable
class SearchResultHasError implements SearchResult {
  final Object error;

  const SearchResultHasError(this.error);
}

@immutable
class SearchResultWithResults implements SearchResult {
  final List<Thing> results;

  const SearchResultWithResults(this.results);
}
