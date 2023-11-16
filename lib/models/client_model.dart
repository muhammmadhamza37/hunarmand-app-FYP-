

class ClientModel {


  String? firstName;
  String? lastName;
  String? email;
  String? password;
  String? contact;
  String? uid;
  String? cnic;
  String? city;
  String? role;
  String? imageUrl;


  ClientModel({
    required this.firstName,required this.lastName,required this.email,required this.password,
    required this.contact,required this.uid,required this.cnic,required this.city, required this.role, required this.imageUrl
});

  Map<String, dynamic> toJson()
  {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['email'] = email;
    map['password'] = password;
    map['contact'] = contact;
    map['uid'] = uid;
    map['cnic'] = cnic;
    map['city'] = city;
    map['role'] = role;
    map['imgUrl'] = imageUrl;

    return map;
  }





}