class User {
  int? id;
  String username;
  String email;
  String akses;
  String passwords;

  User({
    this.id,
    required this.username,
    required this.email,
    required this.akses,
    required this.passwords,
  });

  factory User.fromSQLite(Map map) {
    return User(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      akses: map['akses'],
      passwords: map['passwords'],
    );
  }

  static List<User> fromSQLiteList(List<Map> listMap) {
    List<User> users = [];
    for (Map item in listMap) {
      users.add(User.fromSQLite(item));
    }
    return users;
  }

  factory User.empty() {
    return User(username: '', email: '', akses: '', passwords: '');
  }
}
