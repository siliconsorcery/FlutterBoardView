import 'package:boardview/board_item.dart';
import 'package:boardview/board_list.dart';
import 'package:boardview/boardview.dart';
import 'package:boardview/boardview_controller.dart';
import 'package:example/board_item_object.dart';
import 'package:example/board_list_object.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      title: 'BoardView Demo',
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Kanban(),
      ),
    );
  }
}

class Kanban extends StatefulWidget {
  const Kanban({Key? key}) : super(key: key);

  @override
  State<Kanban> createState() => _KanbanState();
}

class _KanbanState extends State<Kanban> {
  final List<BoardListObject> _listData = [
    BoardListObject(title: 'Backlog', items: [
      BoardItemObject('A'),
      BoardItemObject('B'),
      BoardItemObject('C'),
      BoardItemObject('D'),
    ]),
    BoardListObject(title: 'Working', items: [
      BoardItemObject('X'),
      BoardItemObject('Y'),
      BoardItemObject('Z'),
    ]),
    BoardListObject(title: 'Done', items: [
      BoardItemObject('1'),
      BoardItemObject('2'),
    ]),
  ];

  BoardViewController boardViewController = BoardViewController();

  @override
  Widget build(BuildContext context) {
    List<BoardList> lists = [];
    for (int i = 0; i < _listData.length; i++) {
      lists.add(_createBoardList(_listData[i]) as BoardList);
    }
    return BoardView(
      lists: lists,
      boardViewController: boardViewController,
    );
  }

  Widget _buildBoardItem(BoardItemObject itemObject) {
    return BoardItem(
        onStartDragItem: (
          int? listIndex,
          int? itemIndex,
          BoardItemState? state,
        ) {},
        onDropItem: (
          int? listIndex,
          int? itemIndex,
          int? oldListIndex,
          int? oldItemIndex,
          BoardItemState? state,
        ) {
          if (listIndex == null || oldListIndex == null || oldItemIndex == null || itemIndex == null) {
            return;
          }
          var item = _listData[oldListIndex].items[oldItemIndex];
          _listData[oldListIndex].items.removeAt(oldItemIndex);
          _listData[listIndex].items.insert(itemIndex, item);
        },
        onTapItem: (int? listIndex, int? itemIndex, BoardItemState? state) async {},
        item: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(itemObject.title),
          ),
        ));
  }

  Widget _createBoardList(BoardListObject list) {
    List<BoardItem> items = [];
    for (int i = 0; i < list.items.length; i++) {
      items.insert(i, _buildBoardItem(list.items[i]) as BoardItem);
    }

    return BoardList(
      onStartDragList: (int? listIndex) {},
      onTapList: (int? listIndex) async {},
      onDropList: (int? listIndex, int? oldListIndex) {
        if (listIndex == null || oldListIndex == null) {
          return;
        }
        var list = _listData[oldListIndex];
        _listData.removeAt(oldListIndex);
        _listData.insert(listIndex, list);
      },
      headerBackgroundColor: const Color.fromARGB(255, 235, 236, 240),
      backgroundColor: const Color.fromARGB(255, 235, 236, 240),
      header: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Text(
              list.title,
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ),
      ],
      items: items,
    );
  }
}
