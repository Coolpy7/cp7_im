import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ChatMessage extends StatelessWidget {
  final AnimationController animationController;
  final String name;
  var content;
  final String type;
  final String avatar;
  final String senderId;
  final int showType;

  ChatMessage({
    this.name,
    this.content,
    this.type,
    this.avatar,
    this.senderId,
    this.showType,
    this.animationController
  });

  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
      sizeFactor:
      new CurvedAnimation(parent: animationController, curve: Curves.decelerate),
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          children: this.showType == 0
              ? getSentMessageLayout()
              : getReceivedMessageLayout(),
        ),
      ),
    );
  }

  returnTalkType(type, val) {
    switch (type) {
      case 'text':
        return new Text(val,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            maxLines: 100,
            textAlign: TextAlign.left,
            style: new TextStyle(
              height: 1,
            ));
        break;
      case 'image':
        return new Image.file(val);
        break;
      case 'text':
        return new Text(val);
        break;
    }
  }

  List<Widget> getSentMessageLayout() {
    return <Widget>[
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Text(this.name,
                style: new TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
            new Container(
              margin: new EdgeInsets.only(left: 20.0),
              padding: new EdgeInsets.all(10.0),
              decoration: new BoxDecoration(
                  color: Color(0xFFebebf3),
                  borderRadius: new BorderRadius.circular(10.0)
              ),
              child: new LimitedBox(
                  child: returnTalkType(type, content)
              ),
            ),
          ],
        ),
      ),
      new Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          new Container(
              margin: const EdgeInsets.only(left: 8.0),
              child: new CircleAvatar(
                backgroundImage:
                new NetworkImage(this.avatar),
              )),
        ],
      ),
    ];
  }

  List<Widget> getReceivedMessageLayout() {
    return <Widget>[
      new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
              margin: const EdgeInsets.only(right: 8.0),
              child: new CircleAvatar(
                backgroundImage:
                new NetworkImage(this.avatar),
              )),
        ],
      ),
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(this.name,
                style: new TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
            new Container(
                margin: new EdgeInsets.only(right: 20.0),
                padding: new EdgeInsets.all(10.0),
                decoration: new BoxDecoration(
                    color: Color(0xFFebebf3),
                    borderRadius: new BorderRadius.circular(10.0)
                ),
                child: new LimitedBox(
                  child: returnTalkType(type, content),
                )
            ),
          ],
        ),
      ),
    ];
  }
}
