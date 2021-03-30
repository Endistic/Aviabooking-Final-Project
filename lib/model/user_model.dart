class Contact {
  static const tblContact = 'contacts';
  static const colId = 'id';
  static const coluId = 'uId';
  static const colemail = 'email';
  static const colpassword = 'password';

  Contact({this.id, this.email, this.password, this.uId});

  Contact.fromMap(Map<String, dynamic> map) {
    id = map[colId];
    uId = map[coluId];
    email = map[colemail];
    password = map[colpassword];
  }

  int id;
  String uId;
  String email;
  String password;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      coluId: uId,
      colemail: email,
      colpassword: password
    };

    if (id != null) map[colId] = id;
    return map;
  }
}
