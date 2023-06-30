import 'package:flutter/material.dart';
import 'package:rxdarttutorial/bloc/search_result.dart';

import '../models/animal.dart';
import '../models/person.dart';

class SearchResultView extends StatelessWidget {
  final Stream<SearchResult?> searchResult;
  const SearchResultView({super.key, required this.searchResult});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: searchResult,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final result = snapshot.data;

            if (result is SearchResultHasError) {
              return const Text("Error");
            } else if (result is SearchResultLoading) {
              return const CircularProgressIndicator();
            } else if (result is SearchResultNoResult) {
              return const Text("No Result");
            } else if (result is SearchResultWithResults) {
              final results = result.results;

              return Expanded(
                child: ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final item = results[index];
                      String title = '';
                      if (item is Animal) {
                        title = "Animal";
                      } else if (item is Person) {
                        title = "Person";
                      } else {
                        title = "Unknown";
                      }

                      return ListTile(
                        title: Text(title),
                        subtitle: Text(item.toString()),
                      );
                    }),
              );
            }
          } else {
            return const Text("Waiting");
          }

          return const Text("Unknown state");
        });
  }
}
