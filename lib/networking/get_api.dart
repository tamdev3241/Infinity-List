import 'dart:convert';
import 'package:demo_bloc_infinitylist/models/comment.dart';
import 'package:http/http.dart' as http;

Future<List<Comment>> getCommentsFromApi(int start, int limit) async {
  final url =
      "https://jsonplaceholder.typicode.com/comments?_start=$start&_limit=$limit";
  final http.Client httpClient = http.Client();
  try {
    final response = await httpClient.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body) as List;
      //convert responseData to List of comment ?
      final List<Comment> comments =
          responseData.map((comment) => Comment.fromJson(comment)).toList();
      return comments;
    } else {
      return [];
    }
  } catch (exception) {
    print('Exception : ' + exception.toString());
    return [];
  }
}
