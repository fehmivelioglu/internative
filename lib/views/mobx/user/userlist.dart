import 'package:mobx/mobx.dart';

import '../../../core/service.dart';

part 'userlist.g.dart';

class UserListStore = UserList with _$UserListStore;

abstract class UserList with Store {
  final Service _service = Service.getInstance();
  @observable
  ObservableList<String> friends = ObservableList<String>();

  @action
  void removeFromFriends(String id) {
    friends.removeWhere((element) => element == id);
  }

  @action
  void addToFriends(String id) {
    friends.add(id);
  }

  @action
  void setFriends(List ids) {
    for (var i = 0; i < ids.length; i++) {
      friends.add(ids[i].id);
    }
  }

  @action
  Future<void> getFriendList() async {
    var res = await _service.getFriendList();
    setFriends(res);
  }
}
