class User {
  final String username;
  final String email;
  final String password;
  final String contact;

  const User({this.username, this.email, this.password, this.contact});

  User.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        email = json['email'],
        password = json['password'],
        contact = json['contact'];

  User.fromJsonUser(Map<dynamic, dynamic> json)
      : username = json['username'],
        email = json['email'],
        password = '',
        contact = '';

  Map<String, dynamic> toJson() => {
        'username': username ?? '',
        'email': email ?? '',
        'password': password ?? '',
        'contact': contact ?? ''
      };
}
