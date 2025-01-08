import 'package:content_managment_app_test/logic/home_state.dart';
import 'package:content_managment_app_test/repo/model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class ContentCubit extends Cubit<ContentState> {
  ContentCubit() : super(ContentState());

  final Uuid _uuid = Uuid();

  void addContent(ContentType type, String data) {
    final newContent = Content(id: _uuid.v4(), type: type, data: data);
    final updatedContents = List<Content>.from(state.contents)..add(newContent);
    emit(state.copyWith(contents: updatedContents));
  }

  void removeContent(String id) {
    final updatedContents = state.contents.where((content) => content.id != id).toList();
    emit(state.copyWith(contents: updatedContents));
  }
}