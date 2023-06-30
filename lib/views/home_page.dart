import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdarttutorial/bloc/search_bloc.dart';
import 'package:rxdarttutorial/views/search_result_view.dart';

import '../bloc/api.dart';
import "dart:developer" as devtools show log;

extension Log on Object {
  void log() => devtools.log(toString());
}

void testIt() async {
  final stream1 = Stream.periodic(
      const Duration(seconds: 1), (count) => "Stream 1, count=$count");
  final stream2 = Stream.periodic(
      const Duration(seconds: 10), (count) => "Stream 2, count=$count");

  final combined = Rx.combineLatest2(
      stream1, stream2, (one, two) => "one is $one and two is $two");

  await for (final value in combined) {
    value.log();
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final SearchBloc _searchBloc;

  @override
  void initState() {
    super.initState();

    _searchBloc = SearchBloc(api: Api());
  }

  @override
  void dispose() {
    _searchBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    testIt();
    return Scaffold(
      appBar: AppBar(title: const Text("Search")),
    );
  }
}
