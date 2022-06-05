import 'package:example/board_item_object.dart';

class BoardListObject {
  late String title;
  late List<BoardItemObject> items;

  BoardListObject({
    required this.title,
    required this.items,
  });
}
