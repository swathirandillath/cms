
import 'package:content_managment_app_test/repo/model.dart';

class ContentState {
  final List<Content> contents;

  ContentState({this.contents = const []});

  ContentState copyWith({List<Content>? contents}) {
    return ContentState(contents: contents ?? this.contents);
  }
}
