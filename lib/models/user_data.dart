class UserData{
  final String uid;

  UserData({required this.uid});

  factory UserData.initialData() {
    return UserData(
      uid: '',
      // email: '',
      // firstName: '',
      // lastName: '',
      // phone: '',
      // dateCreated: null,
      // isVerified: null,
    );
  }
}