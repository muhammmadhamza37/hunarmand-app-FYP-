

class WorkerModel {


  String? firstName;
  String? lastName;
  String? email;
  String? password;
  String? contact;
  String? uid;
  String? cnic;
  String? city;
  String? role;
  String? skill;
  String? imageUrl;
  String? bio;
  String? hourlyPrice;
  String? rating;
  String? projects;


  WorkerModel({
    required this.firstName,required this.lastName,required this.email,required this.password,
    required this.contact,required this.uid,required this.cnic,required this.city, required this.role, required this.skill, required this.imageUrl,
    required this.bio, required this.hourlyPrice, required this.rating, required this.projects
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
    map['imageUrl'] = imageUrl;
    map['role'] = role;
    map['skill'] = skill;
    map['bio'] = bio;
    map['price'] = hourlyPrice;
    map['rating'] = rating;
    map['projects'] = projects;

    return map;
  }





}