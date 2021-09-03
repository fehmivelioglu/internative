class FormValidator {
  String validateEmail(String value) {
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      return 'Geçerli mail adresi girmelisiniz';
    } else if (value.isEmpty) {
      return 'Lütfen mail adresinizi giriniz.';
    }
    return null;
  }

  String validatePassword(String value) {
    if (value.isEmpty) {
      return 'Lütfen şifrenizi giriniz.';
    }
    return null;
  }
}
