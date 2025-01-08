enum ContentType { text, image, video }

class Content {
  final String id;
  final ContentType type;
  final String data; // Text or file path for image/video

  Content({required this.id, required this.type, required this.data});
}