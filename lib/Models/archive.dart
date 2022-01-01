class ArchiveModel {
  int? modifiedOn;
  String? userId;
  int? createdOn;
  String? note;
  bool? paid;
  String? fileName;
  bool? signed;
  String? docId;
  FileData? fileData;

  ArchiveModel(
      {this.modifiedOn,
        this.userId,
        this.createdOn,
        this.note,
        this.paid,
        this.fileName,
        this.signed,
        this.docId,
        this.fileData});

  ArchiveModel.fromJson(Map<String, dynamic> json) {
    modifiedOn = json['modifiedOn'];
    userId = json['userId'];
    createdOn = json['createdOn'];
    note = json['note'];
    paid = json['paid'];
    fileName = json['fileName'];
    signed = json['signed'];
    docId = json['docId'];
    fileData = json['fileData'] != null
        ? new FileData.fromJson(json['fileData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['modifiedOn'] = this.modifiedOn;
    data['userId'] = this.userId;
    data['createdOn'] = this.createdOn;
    data['note'] = this.note;
    data['paid'] = this.paid;
    data['fileName'] = this.fileName;
    data['signed'] = this.signed;
    data['docId'] = this.docId;
    if (this.fileData != null) {
      data['fileData'] = this.fileData!.toJson();
    }
    return data;
  }
}

class FileData {
  String? md5Hash;
  String? timeStorageClassUpdated;
  String? selfLink;
  String? cacheControl;
  String? metageneration;
  String? generation;
  String? crc32c;
  String? storageClass;
  String? size;
  String? etag;
  String? timeCreated;
  String? bucket;
  String? kind;
  String? mediaLink;
  String? id;
  String? contentEncoding;
  String? name;
  String? updated;
  String? contentType;

  FileData(
      {this.md5Hash,
        this.timeStorageClassUpdated,
        this.selfLink,
        this.cacheControl,
        this.metageneration,
        this.generation,
        this.crc32c,
        this.storageClass,
        this.size,
        this.etag,
        this.timeCreated,
        this.bucket,
        this.kind,
        this.mediaLink,
        this.id,
        this.contentEncoding,
        this.name,
        this.updated,
        this.contentType});

  FileData.fromJson(Map<String, dynamic> json) {
    md5Hash = json['md5Hash'];
    timeStorageClassUpdated = json['timeStorageClassUpdated'];
    selfLink = json['selfLink'];
    cacheControl = json['cacheControl'];
    metageneration = json['metageneration'];
    generation = json['generation'];
    crc32c = json['crc32c'];
    storageClass = json['storageClass'];
    size = json['size'].toString();
    etag = json['etag'];
    timeCreated = json['timeCreated'];
    bucket = json['bucket'];
    kind = json['kind'];
    mediaLink = json['mediaLink'];
    id = json['id'];
    contentEncoding = json['contentEncoding'];
    name = json['name'];
    updated = json['updated'];
    contentType = json['contentType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['md5Hash'] = this.md5Hash;
    data['timeStorageClassUpdated'] = this.timeStorageClassUpdated;
    data['selfLink'] = this.selfLink;
    data['cacheControl'] = this.cacheControl;
    data['metageneration'] = this.metageneration;
    data['generation'] = this.generation;
    data['crc32c'] = this.crc32c;
    data['storageClass'] = this.storageClass;
    data['size'] = this.size;
    data['etag'] = this.etag;
    data['timeCreated'] = this.timeCreated;
    data['bucket'] = this.bucket;
    data['kind'] = this.kind;
    data['mediaLink'] = this.mediaLink;
    data['id'] = this.id;
    data['contentEncoding'] = this.contentEncoding;
    data['name'] = this.name;
    data['updated'] = this.updated;
    data['contentType'] = this.contentType;
    return data;
  }
}