
class PostUserEntity {
   String? email;
   String? password;
   String? role;
  final String namefull;
  final String lastname;  
  final String phone;
  final String address;
  final int age;           
  final String gender;
  final String bloodtype;
  final String ine;
  final int zipcode;        
  final String city;
  final String username;
  final String dataofbirth;
   String? medicalSummary;
  
  PostUserEntity({
     this.email,
     this.password,
     this.role,
    required this.namefull,
    required this.lastname, 
    required this.phone,
    required this.address,
    required this.age,
    required this.gender,
    required this.bloodtype,
    required this.ine,
    required this.zipcode,
    required this.city,
    required this.username,
    required this.dataofbirth,
     this.medicalSummary,
  });
}