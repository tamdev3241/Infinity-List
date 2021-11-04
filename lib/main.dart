import 'package:demo_bloc_infinitylist/UI/post_list.dart';
import 'package:demo_bloc_infinitylist/blocs/comment_bloc.dart';
import 'package:demo_bloc_infinitylist/blocs/comment_events.dart';
import 'package:demo_bloc_infinitylist/helper/app_bloc_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  Bloc.observer = AppBlocObserver();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: BlocProvider(
          create: (context) => CommentBloc()..add(CommentFetchedEvent()),
          child: InfiniteList(),
        ));
  }
}
