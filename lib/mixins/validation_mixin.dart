class ValidationMixin {
  String validateEmail(String value) {
    if (!value.contains('@')) {
      return 'Insira um e-mail válido';
    }
    return null;
  }

  String validatePassword(String value) {
    if (value.length < 4) {
      return 'A senha precisa de pelo menos 8 caracteres!';
    }
    return null;
  }
}
