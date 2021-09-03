import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../core/service.dart';
import '../../core/sharedManager.dart';
import '../../core/user_model.dart';
import '../components/customSnackbar.dart';
import '../components/customWidgets.dart';
import '../mobx/user/userlist.dart';

class DiscoverScreen extends StatelessWidget {
  final CustomWidgets _widgets = CustomWidgets.instance;
  final Service _service = Service.getInstance();
  final SharedManager _sharedManager = SharedManager.instance;
  final CustomSnackBar _snackBar = CustomSnackBar.instance;
  final UserListStore _listStore = UserListStore();

  @override
  Widget build(BuildContext context) {
    _listStore.getFriendList();
    return Scaffold(
      appBar: _widgets.customAppBar(),
      body: Center(
        child: FutureBuilder(
            future: _service.getUsers(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    return ListView.separated(
                        separatorBuilder: (context, index) =>
                            Container(height: 1, color: Colors.blue),
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          if (_sharedManager.getEmail ==
                              snapshot.data[index].email) {
                            return userListTile(snapshot.data[index], context);
                          }
                          return Observer(
                              builder: (context) =>
                                  userListTile(snapshot.data[index], context));
                        });
                  }
                  return Text('Kullanıcı bulunamadı..');
                  break;
                default:
                  return CircularProgressIndicator();
              }
            }),
      ),
    );
  }

  ListTile userListTile(UserModel user, BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.pushNamed(context, '/profileDetail',
            arguments: {'id': user.id});
      },
      title: Text(user.fullName),
      subtitle: Text(user.email),
      trailing: _sharedManager.getEmail != user.email
          ? TextButton.icon(
              onPressed: () async {
                await userOperationsMethod(user, context);
              },
              icon: Icon(_listStore.friends.contains(user.id)
                  ? Icons.remove
                  : Icons.add),
              label: Text(_listStore.friends.contains(user.id)
                  ? 'Arkadaşlarımdan\n Çıkar'
                  : 'Arkadaş Ekle'))
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
