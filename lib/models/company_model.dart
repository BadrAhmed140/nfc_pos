class CompanyModel {
  int id;
  String internalCode;
  String companyName;
  String responsible;
  String contact;
  int active;
  int points;

  CompanyModel(
      {required this.id,
      required this.internalCode,
      required this.companyName,
      required this.responsible,
      required this.contact,
      required this.active,
      required this.points});

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'],
      internalCode: json['internal_code'],
      companyName: json['company_name'],
      responsible: json['responsible'],
      contact: json['contact'],
      active: json['active'],
      points: json['points'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['internal_code'] = internalCode;
    data['company_name'] = companyName;
    data['responsible'] = responsible;
    data['contact'] = contact;
    data['active'] = active;
    data['points'] = points;
    return data;
  }
}
