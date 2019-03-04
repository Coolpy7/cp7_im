import 'package:cp7_im/comm/userListItem.dart';
import 'package:cp7_im/pages/home/floatButton.dart';
import 'package:flutter/material.dart';
import '../user/drawer.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  final List<UserListItem> _chats = <UserListItem>[];
  int _lastClickTime = 0;
  bool btnShow = true;

  List<Map> userInfoList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userInfoList = [
      {
        'name': 'Only',
        'id': "2",
        'checkInfo': '砖石一颗即永恒',
        'lastTime': '16.18',
        'imageUrl':
        'https://ss1.baidu.com/6ONXsjip0QIZ8tyhnq/it/u=1667994205,255365672&fm=5',
        'backgroundUrl':
        'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1544591217574&di=ccd0b58aa181af2a0ef5dfc44266fde2&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fimage%2Fc0%253Dshijue1%252C0%252C0%252C294%252C40%2Fsign%3D0f22919fb8b7d0a26fc40cdea3861c7c%2F0df431adcbef7609e92064b224dda3cc7cd99ef0.jpg'
      },
      {
        'name': '哈哈',
        'id': "3",
        'checkInfo': '呵呵',
        'lastTime': '24.00',
        'imageUrl':
        'https://ss1.baidu.com/6ONXsjip0QIZ8tyhnq/it/u=2406161785,701397900&fm=5',
        'backgroundUrl':
        'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1544591217574&di=dd17c39c2f725d8e3f4fd69a668c5d9b&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fimage%2Fc0%253Dshijue1%252C0%252C0%252C294%252C40%2Fsign%3D93cf8a986f380cd7f213aaaec92dc741%2F902397dda144ad347a33f2afdaa20cf431ad850d.jpg'
      },
      {
        'name': '呵呵',
        'id': "4",
        'checkInfo': '干嘛,呵呵, 去洗澡',
        'lastTime': '10.20',
        'imageUrl':
        'https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=1853832225,307688784&fm=5',
        'backgroundUrl':
        'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1544591217574&di=2189213cef3d70c482f52359d2727d15&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fimgad%2Fpic%2Fitem%2F810a19d8bc3eb13584856f6fac1ea8d3fc1f44a0.jpg'
      },
      {
        'name': 'Dj',
        'id': "5",
        'checkInfo': '如果我是Dj你会爱我吗',
        'lastTime': '19.28',
        'imageUrl':
        'https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=2247692397,1189743173&fm=5',
        'backgroundUrl': ''
      }
    ];

    for (var i = 0; i < userInfoList.length; i++) {
      UserListItem chattab = new UserListItem(
        type: 1,
        current: userInfoList[i],
      );
      _chats.insert(0, chattab);
    }

    UserListItem chat = new UserListItem(
      type: 0,
    );
    setState(() {
      _chats.insert(0, chat);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        // 双击退出应用
        int nowTime = new DateTime.now().microsecondsSinceEpoch;
        if (_lastClickTime != 0 && nowTime - _lastClickTime > 1500) {
          return new Future.value(true);
        } else {
          _lastClickTime = new DateTime.now().microsecondsSinceEpoch;
          new Future.delayed(const Duration(milliseconds: 1500), () {
            _lastClickTime = 0;
          });
          return new Future.value(false);
        }
      },
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text(
            'WeChat',
            style: new TextStyle(color: const Color(0xFFFFFFFF)),
          ),
          centerTitle: true,
          actions: <Widget>[
            PopupMenuButton(
              offset: Offset(0.0, 60.0),
              icon: Icon(Icons.add),
              itemBuilder: (_) {
                return [
                  new PopupMenuItem(child: new Text('发起群聊'), value: '1'),
                  new PopupMenuItem(child: new Text('扫一扫'), value: '1'),
                  new PopupMenuItem(child: new Text('收付款'), value: '1'),
                  new PopupMenuItem(child: new Text('帮助与反馈'), value: '1'),
                ];
              },
            )
          ],
        ),
        drawer: new Index_Drawer(),
        body: new Stack(
          children: <Widget>[
            new Container(
              child: new ListView.builder(
                itemBuilder: (_, int index) => _chats[index],
                itemCount: _chats.length,
              )
            ),
            new MenuFloatButton()
          ],
        ),
       ),
    );
  }
}
