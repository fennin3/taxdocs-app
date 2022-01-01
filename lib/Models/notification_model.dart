class NotificationModel {
  String? id;
  String? userId;
  bool? status;
  int? modifiedOn;
  String? message;
  int? createdOn;

  NotificationModel(
      {this.id,
        this.userId,
        this.status,
        this.modifiedOn,
        this.message,
        this.createdOn});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    status = json['status'];
    modifiedOn = json['modifiedOn'];
    message = json['message'];
    createdOn = json['createdOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['status'] = this.status;
    data['modifiedOn'] = this.modifiedOn;
    data['message'] = this.message;
    data['createdOn'] = this.createdOn;
    return data;
  }
}