import 'package:demo_bloc_infinitylist/blocs/comment_bloc.dart';
import 'package:demo_bloc_infinitylist/blocs/comment_events.dart';
import 'package:demo_bloc_infinitylist/blocs/comment_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InfiniteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _InfiniteList();
}

class _InfiniteList extends State<InfiniteList> {
  CommentBloc _commentBloc;
  //scroll controller
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _commentBloc = BlocProvider.of(context);

    _scrollController.addListener(() {
      final maxScrollExtent = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      if (maxScrollExtent == currentScroll) {
        _commentBloc.add(CommentFetchedEvent());
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _commentBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Infinitial List"),
      ),
      body: SafeArea(
        child: BlocBuilder<CommentBloc, CommentState>(
          builder: (context, state) {
            if (state is CommentStateInitial) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is CommentStateFailure) {
              return Center(
                child: Text(
                  'Cannot load comments from Server',
                  style: TextStyle(fontSize: 22, color: Colors.red),
                ),
              );
            }
            if (state is CommentStateSuccess) {
              if (state.comments.isEmpty) {
                return Center(
                  child: Text('Empty comments !'),
                );
              }
              return ListView.builder(
                itemBuilder: (BuildContext buildContext, int index) {
                  if (index >= state.comments.length) {
                    return Container(
                      alignment: Alignment.center,
                      child: Center(
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      margin: EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.lightBlueAccent,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: ListTile(
                        leading: Text(
                          '${state.comments[index].id}',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 50.0,
                          ),
                        ),
                        title: Text(
                          '${state.comments[index].email}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        isThreeLine: true,
                        subtitle: Text(
                          '${state.comments[index].body}',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    );
                  }
                },
                itemCount: state.hasReachedEnd
                    ? state.comments.length
                    : state.comments.length + 1, //add more item
                controller: _scrollController,
              );
            }
            return Center(
              child: Text('Other states..'),
            ); //never run this line, only fix warning.
          },
        ),
      ),
    );
  }
}
