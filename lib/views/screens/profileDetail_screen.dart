import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../core/service.dart';
import '../../core/sharedManager.dart';
import '../../core/user_model.dart';
import '../components/customSnackbar.dart';
import '../components/customWidgets.dart';
import '../mobx/user/userlist.dart';

class ProfileDetailScreen extends StatelessWidget {
  final CustomWidgets _widgets = CustomWidgets.instance;
  final Service _service = Service.getInstance();
  final SharedManager _sharedManager = SharedManager.instance;
  final CustomSnackBar _snackBar = CustomSnackBar.instance;
  final UserListStore _listStore = UserListStore();
  @override
  Widget build(BuildContext context) {
    var id = (ModalRoute.of(context).settings.arguments as Map);
    _listStore.getFriendList();
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: _widgets.customAppBar(),
      body: FutureBuilder(
          future: _service.getUserDetail(id['id']),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                if (snapshot.hasData) {
                  UserModel user = snapshot.data;
                  return Column(
                    children: [
                      Row(children: [
                        networkImage(user.profilePhoto),
                        userDetail(user)
                      ]),
                      friendsList(user),
                    ],
                  );
                }
                return Text('Kullanıcı bulunamadı..');
                break;
              default:
                return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  Expanded friendsList(UserModel user) {
    return Expanded(
      child: ListView.builder(
        itemCount: user.friendIds.length,
        itemBuilder: (BuildContext context, int index) {
          return FutureBuilder(
              future: _service.getUserDetail(
                user.friendIds[index],
              ),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    if (snapshot.hasData) {
                      return userListTile(snapshot.data, context);
                    }
                    return Container();
                    break;
                  default:
                    return Container();
                }
              });
        },
      ),
    );
  }

  Expanded userDetail(UserModel user) {
    return Expanded(
        child: Container(
      height: 220,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), bottomRight: Radius.circular(30)),
          color: Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          userDetailRichTextMethod('Kullanıcı Adı: ', user.fullName),
          userDetailRichTextMethod('Email: ', user.email),
          userDetailRichTextMethod(
              'Doğum Tarihi: ', user.birthDate.substring(0, 10)),
          _sharedManager.getEmail != user.email
              ? Container(
                  padding: EdgeInsets.only(top: 10),
                  width: double.infinity,
                  child: Align(alignment: Alignment.bottomRight,
                                      child: Observer(
                        builder: (context) => TextButton.icon(
                            onPressed: () {
                              userOperationsMethod(user, context);
                            },
                            icon: Icon(_listStore.friends.contains(user.id)
                                ? Icons.remove
                                : Icons.add),
                            label: Text(
                              _listStore.friends.contains(user.id)
                                  ? 'Arkadaşlarımdan\n Çıkar'
                                  : 'Arkadaş Ekle',
                            ))),
                  ),
                )
              : Container()
        ],
      ),
    ));
  }

  RichText userDetailRichTextMethod(String title, String userDetail) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
          text: title,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.red, fontSize: 14)),
      TextSpan(
          text: userDetail, style: TextStyle(color: Colors.black, fontSize: 16))
    ]));
  }

  Container networkImage(String imgUrl) => Container(
      // padding:EdgeInsets.only(bottom:5),
      height: 250,
      width: 135,
      padding: EdgeInsets.only(left: 5, bottom: 14, top: 14),
      child: Image.network(
        imgUrl,
        fit: BoxFit.fill,
      ));

  ListTile userListTile(UserModel user, BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.pushNamed(context, '/profileDetail',
            arguments: {'id': user.id});
      },
      title: Text(user.fullName),
      subtitle: Text(user.email),
      trailing: _sharedManager.getEmail != user.email
          ? Container(
              child: TextButton.icon(
                  onPressed: () async {
                    await userOperationsMethod(user, context);
                  },
                  icon: Observer(
                    builder: (context) => Icon(
                        _listStore.friends.contains(user.id)
                            ? Icons.remove
                            : Icons.add),
                  ),
                  label: Observer(
                      builder: (context) => Text(
                          _listStore.friends.contains(user.id)
                              ? 'Arkadaşlarımdan\n Çıkar'
                              : 'Arkadaş\n Ekle'))),
            )
          : null,
      leading: CircleAvatar(
        foregroundImage: NetworkImage(user.profilePhoto),
      ),
    );
  }

  Future userOperationsMethod(UserModel user, BuildContext context) async {
    var res;
    if (_listStore.friends.contains(user.id)) {
      res = await _service.removeFromFriends(user.id);
    } else {
      res = await _service.addToFriends(user.id);
    }

    _snackBar.removeSnackBar(context);
    if (!res['HasError']) {
      _snackBar.showSnackBar(context, Colors.green, res['Message']);
      if (_listStore.friends.contains(user.id)) {
        _listStore.removeFromFriends(user.id);
      } else {
        _listStore.addToFriends(user.id);
      }
    } else {
      if (res['Message'] == 'Bu kullanıcı arkadaş listende bulunmuyor.') {
        _listStore.removeFromFriends(user.id);
      } else if (res['Message'] == 'Bu kullanıcı zaten arkadaş listende var.') {
        _listStore.addToFriends(user.id);
      }
      _snackBar.showSnackBar(context, Colors.red, res['Message']);
    }
  }
}
