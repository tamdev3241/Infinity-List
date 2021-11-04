import 'package:demo_bloc_infinitylist/blocs/comment_events.dart';
import 'package:demo_bloc_infinitylist/blocs/comment_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:demo_bloc_infinitylist/networking/get_api.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final int limitOfPage = 20; //Number item of page

  //initial State
  CommentBloc() : super(CommentStateInitial());

  @override
  Stream<CommentState> mapEventToState(CommentEvent event) async* {
    // Check event is Fetch Api
    if (event is CommentFetchedEvent &&
        !(state is CommentStateSuccess &&
            (state as CommentStateSuccess).hasReachedEnd)) {
      try {
        //Check if "has reached end of a page"
        if (state is CommentStateInitial) {
          //first time loading page
          final comments = await getCommentsFromApi(0, limitOfPage); // get Api
          yield CommentStateSuccess(
            comments: comments,
            hasReachedEnd: false,
          );
        } else if (state is CommentStateSuccess) {
          //load next page
          final currentState = state as CommentStateSuccess;
          int finalIndexOfCurrentPage = currentState.comments.length;
          final comments = await getCommentsFromApi(
            finalIndexOfCurrentPage,
            limitOfPage,
          );
          if (comments.isEmpty) {
            //if isEmpty => end page
            //change current state !
            yield currentState.cloneWith(hasReachedEnd: true);
          } else {
            //not empty, means "not reached end",
            yield CommentStateSuccess(
              comments: currentState.comments + comments, //merge 2 arrays
              hasReachedEnd: false,
            );
          }
        }
      } catch (exception) {
        yield CommentStateFailure();
      }
    }
  }
}
