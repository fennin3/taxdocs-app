class UserModel {
  String? photoURL;
  bool? emailVerified;
  String? email;
  String? customerId;
  int? createdOn;
  bool? canUpload;
  bool? status;
  String? dob;
  int? modifiedOn;
  String? phoneNumber;
  String? displayName;

  UserModel(
      {this.photoURL,
        this.emailVerified,
        this.email,
        this.customerId,
        this.createdOn,
        this.canUpload,
        this.status,
        this.dob,
        this.modifiedOn,
        this.phoneNumber,
        this.displayName});

  UserModel.fromJson(Map<String, dynamic> json) {
    photoURL = json['photoURL'];
    emailVerified = json['emailVerified'];
    email = json['email'];
    customerId = json['customerId'];
    createdOn = json['createdOn'];
    canUpload = json['canUpload'];
    status = json['status'];
    dob = json['dob'];
    modifiedOn = json['modifiedOn'];
    phoneNumber = json['phoneNumber'];
    displayName = json['displayName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['photoURL'] = this.photoURL;
    data['emailVerified'] = this.emailVerified;
    data['email'] = this.email;
    data['customerId'] = this.customerId;
    data['createdOn'] = this.createdOn;
    data['canUpload'] = this.canUpload;
    data['status'] = this.status;
    data['dob'] = this.dob;
    data['modifiedOn'] = this.modifiedOn;
    data['phoneNumber'] = this.phoneNumber;
    data['displayName'] = this.displayName;
    return data;
  }
}