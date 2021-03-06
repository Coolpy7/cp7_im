import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:open_file/open_file.dart';
import 'package:cp7_im/comm/chatmessage.dart';
import 'package:cp7_im/comm/webBrowser.dart';
import 'package:cp7_im/network/msgbus.dart';
import 'package:cp7_im/util/httpUtil.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progress_dialog/progress_dialog.dart';
import './detailed.dart';

class Talk extends StatefulWidget {
  Talk({Key key, this.detail}) : super(key: key);
  final detail;

  @override
  _TalkState createState() => new _TalkState();
}

class _TalkState extends State<Talk> with TickerProviderStateMixin {
  ProgressDialog pr;

  var fsNode1 = new FocusNode();
  var _textInputController = new TextEditingController();

  bool talkFOT = false;
  bool otherFOT = false;

  final List<ChatMessage> _messages = <ChatMessage>[];

  Animation animationTalk;
  AnimationController controller;

  ScrollController _scrollController;
  bool isLoading = false; // 是否正在加载更多

  var hu = new httpUtil();

  void _getDatas() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      // 模拟数据的延迟加载
      await Future.delayed(Duration(seconds: 2), () {
        setState(() {
          isLoading = false;
          for (int i = 0; i < 4; i++) {
            ChatMessage message = new ChatMessage(
              name: widget.detail['name'],
              senderId: widget.detail['id'],
              avatar: widget.detail['imageUrl'],
              content: '无论你说什么，我都只回你这一句' + DateTime.now().toIso8601String(),
              type: "text",
              showType: 1,
              animationController: new AnimationController(
                duration: new Duration(milliseconds: 70),
                vsync: this,
              ),
            );
            setState(() {
              _messages.insert(_messages.length, message);
            });
            message.animationController.forward();
          }
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
//    hu.baseUrl = 'https://192.168.200.251:9999';

    controller = new AnimationController(
        duration: new Duration(seconds: 1), vsync: this);
    animationTalk = new Tween(begin: 1.0, end: 1.5).animate(controller)
      ..addStatusListener((state) {
        if (state == AnimationStatus.completed) {
          controller.reverse();
        } else if (state == AnimationStatus.dismissed) {
          controller.forward();
        }
      });

    fsNode1.addListener(_focusListener);

    // 初始化ScrollController
    _scrollController = ScrollController();
    // 监听ListView是否滚动到底部
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent) {
        // 这里可以执行上拉加载逻辑
        if (!isLoading){
          // 滑动到了底部
          print('滑动到了底部');
          _getDatas();
        }
      }
    });
  }

  _focusListener() async {
    if (fsNode1.hasFocus) {
      setState(() {
        otherFOT = false;
        talkFOT = false;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    for (ChatMessage message in _messages)
      message.animationController.dispose();
    super.dispose();
    _scrollController.dispose();
  }

  void getImage() async {
    var img = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (img != null) {
//      var res = await hu.PostStream("/api/upload/", {"Authorization":"5b98a753d29aa329e80cfe7d"}, basename(img.path), false, img.readAsBytesSync());
//      if (res["ok"] == true) {
//        print(res);
//      }
      autoTalk(img, 'image');
    }
  }

//  Future<Null> _handleRefresh() async {
//    await Future.delayed(Duration(seconds: 1), () {
//      print('refresh');
//      setState(() {
//        _getDatas();
//        return null;
//      });
//    });
//  }

  autoTalk(val, type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var mySelf = json.decode(prefs.getString('userInfo'));

    if (mySelf['id'] != widget.detail['id']) {}

    ChatMessage message = new ChatMessage(
      name: mySelf['name'],
      senderId: mySelf['id'],
      avatar: mySelf['imageUrl'],
      content: val,
      type: type,
      showType: 0,
      animationController: new AnimationController(
        duration: new Duration(milliseconds: 70),
        vsync: this,
      ),
    );
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();

    Future.delayed(new Duration(seconds: 1), () {
      ChatMessage message = new ChatMessage(
        name: widget.detail['name'],
        senderId: widget.detail['id'],
        avatar: widget.detail['imageUrl'],
        content: '无论你说什么，我都只回你这一句',
        type: "text",
        showType: 1,
        animationController: new AnimationController(
          duration: new Duration(milliseconds: 70),
          vsync: this,
        ),
      );
      setState(() {
        _messages.insert(0, message);
      });
      message.animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, ProgressDialogType.Normal);
    pr.setMessage('加载中...');
    return new WillPopScope(
      onWillPop: () {
//        Navigator.of(context).pushNamedAndRemoveUntil('/home', (_) => false);
        Navigator.of(context).pop();
      },
      child: new Scaffold(
        appBar: new AppBar(
          leading: new IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
//              Navigator.of(context).pushReplacementNamed('/home');
              Navigator.of(context).pop();
            },
          ),
          title: new Text(
            '${widget.detail['name']}',
            style: new TextStyle(fontSize: 20.0),
          ),
          actions: <Widget>[
            new IconButton(
              icon: Icon(Icons.person, size: 30.0),
              onPressed: () {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (_) => new Detailed(detail: widget.detail)));
              },
            )
          ],
          centerTitle: true,
        ),
        body: new Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: <Widget>[
                new Container(
                  margin: new EdgeInsets.symmetric(horizontal: 0),
                  padding: new EdgeInsets.only(bottom: 50.0),
                  // width: MediaQuery.of(context).size.width - 40.0,
//                  child: new RefreshIndicator(
                    child: new ListView.builder(
                      padding: new EdgeInsets.all(3.0),
                      reverse: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (index < _messages.length) {
                          return _messages[index];
                        }
                      },
                      itemCount: _messages.length,
                      controller: _scrollController,
                    ),
//                    onRefresh: _handleRefresh,
//                  ),
                ),
                new Positioned(
                  bottom: 0,
                  left: 0,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                      color: Color(0xFFebebf3),
                      child: new Column(
                        children: <Widget>[
                          new Offstage(
                            offstage: talkFOT,
                            child: new Row(
                              children: <Widget>[
                                new Container(
                                  width: 40.0,
                                  color: Color(0xFFaaaab6),
                                  child: new IconButton(
                                    icon: new Icon(Icons.keyboard_voice),
                                    onPressed: () {
                                      setState(() {
                                        fsNode1.unfocus();
                                        talkFOT = !talkFOT;
                                        otherFOT = false;
                                      });
                                    },
                                  ),
                                ),
                                new Container(
                                  padding: new EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  width:
                                      MediaQuery.of(context).size.width - 140.0,
                                  child: new TextField(
                                    focusNode: fsNode1,
                                    controller: _textInputController,
                                    decoration: new InputDecoration(
                                        border: InputBorder.none,
                                        hintText: '输入你的信息...',
                                        hintStyle: new TextStyle(
                                            color: Color(0xFF7c7c7e))),
                                    onSubmitted: (val) {
                                      if (val != '' && val != null) {
                                        autoTalk(val, 'text');
                                      }
                                      _textInputController.clear();
                                    },
                                  ),
                                ),
                                new IconButton(
                                  icon: Icon(Icons.insert_emoticon,
                                      color: Color(0xFF707072)),
                                  onPressed: () {},
                                ),
                                new IconButton(
                                  icon: Icon(Icons.add_circle_outline,
                                      color: Color(0xFF707072)),
                                  onPressed: () {
                                    setState(() {
                                      fsNode1.unfocus();
                                      otherFOT = !otherFOT;
                                    });
                                  },
                                )
                              ],
                            ),
                          ),
                          new Offstage(
                              // 录音按钮
                              offstage: !talkFOT,
                              child: new Column(
                                children: <Widget>[
                                  new Container(
                                    height: 30.0,
                                    color: Color(0xFFededed),
                                    alignment: Alignment.centerLeft,
                                    child: new IconButton(
                                      icon: Icon(Icons.arrow_back_ios),
                                      onPressed: () {
                                        controller.reset();
                                        controller.stop();
                                        setState(() {
                                          talkFOT = !talkFOT;
                                        });
                                      },
                                    ),
                                  ),
                                  new Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 170.0,
                                    color: Color(0xFFededed),
                                    child: new Center(
                                        child: new AnimatedBuilder(
                                      animation: animationTalk,
                                      builder: (_, child) {
                                        return new GestureDetector(
                                          child: new CircleAvatar(
                                            radius: animationTalk.value * 30,
                                            backgroundColor: Color(0x306b6aba),
                                            child: new Center(
                                              child: Icon(Icons.keyboard_voice,
                                                  size: 30.0,
                                                  color: Color(0xFF6b6aba)),
                                            ),
                                          ),
                                          onLongPress: () {
                                            controller.forward();
                                          },
                                          onLongPressUp: () {
                                            controller.reset();
                                            controller.stop();
                                          },
                                        );
                                      },
                                    )),
                                  ),
                                ],
                              )),
                          new Offstage(
                              // 图片选择
                              offstage: !otherFOT,
                              child: new Padding(
                                  padding: new EdgeInsets.all(10.0),
                                  child: new Column(
                                    children: <Widget>[
                                      new Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 170.0,
                                          color: Color(0xFFededed),
                                          child: Wrap(
                                            spacing: 25.0,
                                            runSpacing: 10.0,
                                            children: <Widget>[
                                              new Container(
                                                width: (MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        100) /
                                                    4,
                                                height: (MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        100) /
                                                    4,
                                                color: Color(0xFFffffff),
                                                child: new IconButton(
                                                  iconSize: 50.0,
                                                  icon: Icon(
                                                      Icons
                                                          .photo_size_select_actual,
                                                      color: Colors.black38),
                                                  onPressed: () {
                                                    getImage();
                                                  },
                                                ),
                                              ),
                                              new Container(
                                                width: (MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        100) /
                                                    4,
                                                height: (MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        100) /
                                                    4,
                                                color: Color(0xFFffffff),
                                                child: new IconButton(
                                                  iconSize: 50.0,
                                                  icon: Icon(Icons.videocam,
                                                      color: Colors.black38),
                                                  onPressed: () {
                                                    eventBus.fire(
                                                        new LocalPushEvent(
                                                            'your channel id',
                                                            'your channel name',
                                                            'your channel description',
                                                            0,
                                                            'plain title',
                                                            'plain body',
                                                            'item x',
                                                            5));
                                                  },
                                                ),
                                              ),
                                              new Container(
                                                width: (MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        100) /
                                                    4,
                                                height: (MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        100) /
                                                    4,
                                                color: Color(0xFFffffff),
                                                child: new IconButton(
                                                  iconSize: 50.0,
                                                  icon: Icon(
                                                      Icons.linked_camera,
                                                      color: Colors.black38),
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        new MaterialPageRoute(
                                                            builder: (context) =>
                                                                new NewsWebPage(
                                                                    "https://www.baidu.com/",
                                                                    'WebViewer')));
                                                  },
                                                ),
                                              ),
                                              new Container(
                                                width: (MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        100) /
                                                    4,
                                                height: (MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        100) /
                                                    4,
                                                color: Color(0xFFffffff),
                                                child: new IconButton(
                                                  iconSize: 50.0,
                                                  icon: Icon(Icons.add_location,
                                                      color: Colors.black38),
                                                  onPressed: () async {
                                                    pr.show();
                                                    //var u = "http://icoolpy.oss-cn-beijing.aliyuncs.com/Coolpy%20HTTP%20API.pdf";
                                                    var u =
                                                        "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1553855796650&di=bb15d4b15612cd5de0f25e768ce592ba&imgtype=0&src=http%3A%2F%2Fimg00.deviantart.net%2Fa501%2Fi%2F2014%2F047%2F5%2Fd%2Fscared_fluttershy_by_techrainbow-d76o6u4.png";
                                                    var res = await hu.GetRaw(u, {});
                                                    if (res != false) {
                                                      Directory appDocDir = await getApplicationDocumentsDirectory();
                                                      String appDocPath = appDocDir.path;
                                                      String fn = basename(u);
                                                      var localfilepath = p.join(appDocPath, fn);
                                                      var file = File(localfilepath);
                                                      file.writeAsBytes(res);
                                                      pr.hide();
                                                      await OpenFile.open(
                                                          localfilepath);
                                                    }
                                                  },
                                                ),
                                              ),
                                              new Container(
                                                width: (MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        100) /
                                                    4,
                                                height: (MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        100) /
                                                    4,
                                                color: Color(0xFFffffff),
                                                child: new IconButton(
                                                  iconSize: 50.0,
                                                  icon: Icon(
                                                      Icons.library_music,
                                                      color: Colors.black38),
                                                  onPressed: () {},
                                                ),
                                              ),
                                              new Container(
                                                width: (MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        100) /
                                                    4,
                                                height: (MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        100) /
                                                    4,
                                                color: Color(0xFFffffff),
                                                child: new IconButton(
                                                  iconSize: 50.0,
                                                  icon: Icon(
                                                      Icons.library_books,
                                                      color: Colors.black38),
                                                  onPressed: () {},
                                                ),
                                              ),
                                              new Container(
                                                width: (MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        100) /
                                                    4,
                                                height: (MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        100) /
                                                    4,
                                                color: Color(0xFFffffff),
                                                child: new IconButton(
                                                  iconSize: 50.0,
                                                  icon: Icon(
                                                      Icons.video_library,
                                                      color: Colors.black38),
                                                  onPressed: () {},
                                                ),
                                              ),
                                              new Container(
                                                width: (MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        100) /
                                                    4,
                                                height: (MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        100) /
                                                    4,
                                                color: Color(0xFFffffff),
                                                child: new IconButton(
                                                  iconSize: 50.0,
                                                  icon: Icon(
                                                      Icons.local_activity,
                                                      color: Colors.black38),
                                                  onPressed: () {},
                                                ),
                                              ),
                                            ],
                                          )),
                                    ],
                                  )))
                        ],
                      )),
                )
              ],
            )),
      ),
    );
  }
}
