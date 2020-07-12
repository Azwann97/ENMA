class NewUser {

  final String id;
  final String name;
  final String email;
  final String ID;
  final String gender;
  final String userType;
  final String PNo;
  final String Faculty;
  final String UImage;
  final String UP;

  NewUser({this.id, this.name, this.email, this.gender, this.ID, this.userType, this.PNo, this.Faculty, this.UImage, this.UP});

  NewUser.fromData(Map<String, dynamic> data)
      : id = data['id'],
        name = data['name'],
        email = data['email'],
        ID = data['UiTM id'],
        gender = data['gender'],
        userType = data['Account Type'],
        PNo = data['Contact Number'],
        Faculty = data['Faculty'],
        UImage = data['Image'],
        UP = data['preference'];

  Map<String, dynamic> toJson() {
    return {
      'user id': id,
      'name': name,
      'email': email,
      'UiTM id': ID,
      'gender': gender,
      'Account Type': userType,
      'Contact Number': PNo,
      'Faculty' : Faculty,
      'User Image' : UImage,
      'preference' :UP,
    };
  }
}