class SettingModel {
  bool? maintenance;
  String? terms;
  String? website;
  String? signatureAmount;
  String? contactEmail;
  String? appName;

  SettingModel(
      {this.maintenance,
        this.terms,
        this.website,
        this.signatureAmount,
        this.contactEmail,
        this.appName});

  SettingModel.fromJson(Map<String, dynamic> json) {
    maintenance = json['maintenance'];
    terms = json['terms'];
    website = json['website'];
    signatureAmount = json['signatureAmount'];
    contactEmail = json['contactEmail'];
    appName = json['appName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['maintenance'] = this.maintenance;
    data['terms'] = this.terms;
    data['website'] = this.website;
    data['signatureAmount'] = this.signatureAmount;
    data['contactEmail'] = this.contactEmail;
    data['appName'] = this.appName;
    return data;
  }
}