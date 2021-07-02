class RegexType{
  static String EMAIL = "^[a-zA-Z0-9.a-zA-Z0-9.!#\$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  static String PASSWORD = "^(?=.*?[a-zA-Z])(?=.*?[0-9]).{6,}\$";
  static String NAME = "[\\wа-яА-Я]+";
}