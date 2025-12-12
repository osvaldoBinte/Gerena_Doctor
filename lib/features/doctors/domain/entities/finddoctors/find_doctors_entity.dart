class FindDoctorsEntity {
  final int userId;
  final String fullName;
  final String? specialty;  
  final String? profilePictureUrl;  
  final int? expreriecetime;
  final String? address; 
  final String? bibliography;
  
  FindDoctorsEntity({
    required this.userId,
    required this.fullName,
    this.specialty,
    this.profilePictureUrl,
    this.expreriecetime,
    this.address,
    this.bibliography,
  });
}