class Vessel {
  final String? id;
  final String? imo;
  final String? vesselName;
  final String? flag;
  final String? type;
  final String? dwt;
  final String? etaUtc;
  final String? vesselEmail;
  final String? managementCompany;
  final String? fleetSize;
  final String? avgAge;
  final String? companyEmail;
  final String? departmentEmail;
  final String? phone;
  final String? web;
  final String? recordedAt;
  final String? originalSheetName;

  Vessel({
    required this.id,
    required this.imo,
    required this.vesselName,
    required this.flag,
    required this.type,
    required this.dwt,
    required this.etaUtc,
    required this.vesselEmail,
    required this.managementCompany,
    required this.fleetSize,
    required this.avgAge,
    required this.companyEmail,
    required this.departmentEmail,
    required this.phone,
    required this.web,
    required this.recordedAt,
    required this.originalSheetName,
  });

  factory Vessel.fromJson(Map<String, dynamic> json) {
    return Vessel(
      id: json['id'],
      imo: json['IMO'],
      vesselName: json['vesselName'],
      flag: json['flag'],
      type: json['type'],
      dwt: json['DWT'],
      etaUtc: json['ETA_UTC'],
      vesselEmail: json['vesselEmail'],
      managementCompany: json['managementCompany'],
      fleetSize: json['fleetSize'],
      avgAge: json['avgAge'],
      companyEmail: json['companyEmail'],
      departmentEmail: json['departmentEmail'],
      phone: json['phone'],
      web: json['web'],
      recordedAt: json['recordedAt'],
      originalSheetName: json['originalSheetName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'IMO': imo,
      'vesselName': vesselName,
      'flag': flag,
      'type': type,
      'DWT': dwt,
      'ETA_UTC': etaUtc.toString(),
      'vesselEmail': vesselEmail,
      'managementCompany': managementCompany,
      'fleetSize': fleetSize,
      'avgAge': avgAge,
      'companyEmail': companyEmail,
      'departmentEmail': departmentEmail,
      'phone': phone,
      'web': web,
      'recordedAt': recordedAt.toString(),
      'originalSheetName': originalSheetName,
    };
  }
}
