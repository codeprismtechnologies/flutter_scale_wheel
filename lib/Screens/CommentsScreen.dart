import 'package:flutter/cupertino.dart';

class CommentsScreen extends StatefulWidget {
  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Container(
        width: 500,
        height: 500,
        color: CupertinoColors.systemRed,
      ),
    );
  }
}
