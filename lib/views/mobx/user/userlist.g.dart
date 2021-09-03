// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userlist.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$UserListStore on UserList, Store {
  final _$friendsAtom = Atom(name: 'UserList.friends');

  @override
  ObservableList<String> get friends {
    _$friendsAtom.reportRead();
    return super.friends;
  }

  @override
  set friends(ObservableList<String> value) {
    _$friendsAtom.reportWrite(value, super.friends, () {
      super.friends = value;
    });
  }

  final _$getFriendListAsyncAction = AsyncAction('UserList.getFriendList');

  @override
  Future<void> getFriendList() {
    return _$getFriendListAsyncAction.run(() => super.getFriendList());
  }

  final _$UserListActionController = ActionController(name: 'UserList');

  @override
  void removeFromFriends(String id) {
    final _$actionInfo = _$UserListActionController.startAction(
        name: 'UserList.removeFromFriends');
    try {
      return super.removeFromFriends(id);
    } finally {
      _$UserListActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addToFriends(String id) {
    final _$actionInfo =
        _$UserListActionController.startAction(name: 'UserList.addToFriends');
    try {
      return super.addToFriends(id);
    } finally {
      _$UserListActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFriends(List<dynamic> ids) {
    final _$actionInfo =
        _$UserListActionController.startAction(name: 'UserList.setFriends');
    try {
      return super.setFriends(ids);
    } finally {
      _$UserListActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
friends: ${friends}
    ''';
  }
}
