import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdarttutorial/bloc/search_result.dart';

import 'api.dart';

@immutable
class SearchBloc {
  final Sink<String> search;
  final Stream<SearchResult?> results;

  SearchBloc._({required this.search, required this.results});

  void dispose() {
    search.close();
  }

  factory SearchBloc({
    required Api api,
  }) {
    final textChanges = BehaviorSubject<String>();

    final results = textChanges
        .distinct()
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap<SearchResult?>((searchTerm) {
      if (searchTerm.isEmpty) {
        return Stream<SearchResult?>.value(null);
      } else {
        return Rx.fromCallable(() => api.search(searchTerm))
            .delay(const Duration(seconds: 1))
            .map((results) => results.isEmpty
                ? SearchResultNoResult()
                : SearchResultWithResults(results))
            .startWith(SearchResultLoading())
            .onErrorReturnWith(
                (error, stackTrace) => SearchResultHasError(error));
      }
    });

    return SearchBloc._(search: textChanges.sink, results: results);
  }
}
