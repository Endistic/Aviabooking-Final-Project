class User {
  final String name;
  final String surname;
  final String tel;
  final String email;
  final String idNo;
 

  User({
    this.name,
    this.surname,
    this.tel,
    this.email,
    this.idNo,
    
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      surname: json['surname'],
      tel: json['tel'],
      email: json['email'],
      idNo: json['idNo'],
      
    );
  }
}
