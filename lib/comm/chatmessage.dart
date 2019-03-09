import 'package:cached_network_image/cached_network_image.dart';
import 'package:cp7_im/comm/FullScreenWrapper.dart';
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
  Image img;

  ChatMessage(
      {this.name,
      this.content,
      this.type,
      this.avatar,
      this.senderId,
      this.showType,
      this.animationController});

  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
      sizeFactor: new CurvedAnimation(
          parent: animationController, curve: Curves.decelerate),
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          children: this.showType == 0
              ? getSentMessageLayout(context)
              : getReceivedMessageLayout(context),
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
        img = new Image.file(val);
        return this.img;
        break;
      case 'text':
        return new Text(val);
        break;
    }
  }

  List<Widget> getSentMessageLayout(BuildContext context) {
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
            new GestureDetector(
              child: new Container(
                margin: new EdgeInsets.only(left: 20.0),
                padding: new EdgeInsets.all(10.0),
                decoration: new BoxDecoration(
                    color: Color(0xFFebebf3),
                    borderRadius: new BorderRadius.circular(10.0)),
                child: new LimitedBox(child: returnTalkType(type, content)),
              ),
              onTap: () {
                clickDo(context);
              },
            ),
          ],
        ),
      ),
      new Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          new Container(
              margin: const EdgeInsets.only(left: 3.0),
              child: new ClipRRect(
                borderRadius: BorderRadius.circular(3.0),
                child: CachedNetworkImage(
                  width: 38.0,
                  height: 38.0,
                  imageUrl: this.avatar,
                  placeholder: (context, url) => new CircularProgressIndicator(),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                ),
              )),
        ],
      ),
    ];
  }

  List<Widget> getReceivedMessageLayout(BuildContext context) {
    return <Widget>[
      new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
              margin: const EdgeInsets.only(right: 3.0),
              child: new ClipRRect(
                borderRadius: BorderRadius.circular(3.0),
                child: CachedNetworkImage(
                  width: 38.0,
                  height: 38.0,
                  imageUrl: this.avatar,
                  placeholder: (context, url) => new CircularProgressIndicator(),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                ),
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
            new GestureDetector(
              child: new Container(
                  margin: new EdgeInsets.only(right: 20.0),
                  padding: new EdgeInsets.all(10.0),
                  decoration: new BoxDecoration(
                      color: Color(0xFFebebf3),
                      borderRadius: new BorderRadius.circular(10.0)),
                  child: new LimitedBox(
                    child: returnTalkType(type, content),
                  )),
              onTap: () {
                clickDo(context);
              },
            ),
          ],
        ),
      ),
    ];
  }

  clickDo(BuildContext context) {
    if (this.type == "image") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const FullScreenWrapper(
                imageProvider: const NetworkImage(
                    "https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=2428991543,2640848292&fm=26&gp=0.jpg"),
                //backgroundDecoration:
                //   BoxDecoration(color: Colors.white),
                //axScale: 2.0,
              ),
        ),
      );
    }
  }
}
