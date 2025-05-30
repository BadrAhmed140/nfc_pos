// user model for this data
/*
{userId: 739178, userType: petrol_station, company_name: , petrol_station: بنزينة المطرية, nbf: 1695730702, exp: 1695817102, iat: 1695730702}
 */
class UserModel {
  final String userId;
  final String userType;
  final String companyName;
  final String petrolStation;
  final String nbf;
  final String exp;
  final String iat;

  UserModel({
    required this.userId,
    required this.userType,
    required this.companyName,
    required this.petrolStation,
    required this.nbf,
    required this.exp,
    required this.iat,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'].toString(),
      userType: json['userType'].toString(),
      companyName: json['company_name'].toString(),
      petrolStation: json['petrol_station'].toString(),
      nbf: json['nbf'].toString(),
      exp: json['exp'].toString(),
      iat: json['iat'].toString(),
    );
  }
  @override
  String toString() {
    return 'UserModel{userId: $userId, userType: $userType, companyName: $companyName, petrolStation: $petrolStation, nbf: $nbf, exp: $exp, iat: $iat}';
  }
}
