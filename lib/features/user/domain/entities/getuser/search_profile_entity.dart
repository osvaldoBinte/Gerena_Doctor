class SearchProfileEntity {
  final int userId;
  final String fullName;
  final String? username;
  final String? specialty;  
  final String? profilePictureUrl;  
  final int? expreriecetime;
  final String? address; 
  final String? bibliography;
  final double?averagerating;
  final String? rol;
  
  SearchProfileEntity({
    required this.userId,
    required this.fullName,
    this.username,
    this.specialty,
    this.profilePictureUrl,
    this.expreriecetime,
    this.address,
    this.bibliography,
    this.averagerating,
    this.rol
  });
}