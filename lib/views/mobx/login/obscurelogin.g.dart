// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'obscurelogin.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ObscureLoginStore on ObscureLogin, Store {
  final _$isObscureAtom = Atom(name: 'ObscureLogin.isObscure');

  @override
  bool get isObscure {
    _$isObscureAtom.reportRead();
    return super.isObscure;
  }

  @override
  set isObscure(bool value) {
    _$isObscureAtom.reportWrite(value, super.isObscure, () {
      super.isObscure = value;
    });
  }

  final _$ObscureLoginActionController = ActionController(name: 'ObscureLogin');

  @override
  void changeObscure() {
    final _$actionInfo = _$ObscureLoginActionController.startAction(
        name: 'ObscureLogin.changeObscure');
    try {
      return super.changeObscure();
    } finally {
      _$ObscureLoginActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isObscure: ${isObscure}
    ''';
  }
}
