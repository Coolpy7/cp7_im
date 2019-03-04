import 'package:cp7_im/pages/home/searchPage.dart';
import 'package:cp7_im/pages/user/talk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

// ignore: must_be_immutable
class UserListItem extends StatelessWidget {
  int type;
  Map current;

  UserListItem({
    this.type,
    this.current,
  });

  final SlidableController slidableController = new SlidableController();

  createUserListItem(context, item) {
    return new GestureDetector(
      child: new Slidable(
        controller: slidableController,
        delegate: new SlidableDrawerDelegate(),
        actionExtentRatio: 0.2,
        child: new Container(
          decoration: new BoxDecoration(
              border: new BorderDirectional(
                  bottom:
                  new BorderSide(color: Color(0xFFe1e1e1), width: 1.0))),
          child: new ListTile(
            leading: new CircleAvatar(
              backgroundImage: new NetworkImage('${item['imageUrl']}'),
            ),
            title: new Text('${item['name']}'),
            subtitle: new Text('${item['checkInfo']}'),
            trailing: new Text('${item['lastTime']}'),
          ),
        ),
        secondaryActions: <Widget>[
          new IconSlideAction(
              caption: '置顶',
              color: Color(0xFF61ab32),
              icon: Icons.vertical_align_top,
              onTap: () {
                // Navigator.of(context).push(
                //   new MaterialPageRoute(
                //    builder: (_) => new Talk(detail: item)
                //   )
                // );
              }),
          new IconSlideAction(
            caption: '删除会话',
            color: Color(0xFFf76767),
            icon: Icons.delete_outline,
            onTap: () => _showSnackBar('Delete'),
          ),
        ],
      ),
      onTap: () {
        Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
          return new Talk(detail: item);
        }));
      },
    );
  }

  createSearchTab(context) {
    return new GestureDetector(
      child: new Container(
          height: 50.0,
          color: new Color(0xFFefeef3),
          child: ListTile(
            leading: Icon(Icons.search),
            title: new Text('搜索'),
            trailing: new IconButton(
              icon: Icon(Icons.keyboard_voice),
              onPressed: () {
                print('语音');
              },
            ),
          )),
      onTap: () {
        Navigator.of(context)
            .push(new MaterialPageRoute(builder: (_) => new SearchPage()));
      },
    );
  }

  _showSnackBar(val) {
    print(val);
  }

  @override
  Widget build(BuildContext context) {
    if (this.type == 0) {
      return createSearchTab(context);
    } else {
      return createUserListItem(context, this.current);
    }
  }
}
