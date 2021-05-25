class RegexType{
  static String EMAIL = "^[a-zA-Z0-9.a-zA-Z0-9.!#\$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  static String PASSWORD = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}\$";
  static String NAME = "[!@#<>?\":_`~;[\]\\|=+)(*&^%0-9-]";
}