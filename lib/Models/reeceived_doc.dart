class ReceivedDoc {
  int? createdOn;
  bool? signed;
  bool? paid;
  String? note;
  String? docId;
  String? userId;
  int? modifiedOn;
  FileData? fileData;
  String? fileName;

  ReceivedDoc(
      {this.createdOn,
        this.signed,
        this.paid,
        this.note,
        this.docId,
        this.userId,
        this.modifiedOn,
        this.fileData,
        this.fileName});

  ReceivedDoc.fromJson(Map<String, dynamic> json) {
    createdOn = json['createdOn'];
    signed = json['signed'];
    paid = json['paid'];
    note = json['note'];
    docId = json['docId'];
    userId = json['userId'];
    modifiedOn = json['modifiedOn'];
    fileData = json['fileData'] != null
        ? new FileData.fromJson(json['fileData'])
        : null;
    fileName = json['fileName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdOn'] = this.createdOn;
    data['signed'] = this.signed;
    data['paid'] = this.paid;
    data['note'] = this.note;
    data['docId'] = this.docId;
    data['userId'] = this.userId;
    data['modifiedOn'] = this.modifiedOn;
    if (this.fileData != null) {
      data['fileData'] = this.fileData!.toJson();
    }
    data['fileName'] = this.fileName;
    return data;
  }
}

class FileData {
  String? cacheControl;
  String? mediaLink;
  String? updated;
  String? metageneration;
  String? timeStorageClassUpdated;
  String? md5Hash;
  String? selfLink;
  String? crc32c;
  String? timeCreated;
  String? etag;
  String? contentType;
  String? id;
  String? storageClass;
  String? name;
  String? generation;
  String? contentEncoding;
  String? kind;
  String? bucket;
  String? size;

  FileData(
      {this.cacheControl,
        this.mediaLink,
        this.updated,
        this.metageneration,
        this.timeStorageClassUpdated,
        this.md5Hash,
        this.selfLink,
        this.crc32c,
        this.timeCreated,
        this.etag,
        this.contentType,
        this.id,
        this.storageClass,
        this.name,
        this.generation,
        this.contentEncoding,
        this.kind,
        this.bucket,
        this.size});

  FileData.fromJson(Map<String, dynamic> json) {
    cacheControl = json['cacheControl'];
    mediaLink = json['mediaLink'];
    updated = json['updated'];
    metageneration = json['metageneration'];
    timeStorageClassUpdated = json['timeStorageClassUpdated'];
    md5Hash = json['md5Hash'];
    selfLink = json['selfLink'];
    crc32c = json['crc32c'];
    timeCreated = json['timeCreated'];
    etag = json['etag'];
    contentType = json['contentType'];
    id = json['id'];
    storageClass = json['storageClass'];
    name = json['name'];
    generation = json['generation'];
    contentEncoding = json['contentEncoding'];
    kind = json['kind'];
    bucket = json['bucket'];
    size = json['size'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cacheControl'] = this.cacheControl;
    data['mediaLink'] = this.mediaLink;
    data['updated'] = this.updated;
    data['metageneration'] = this.metageneration;
    data['timeStorageClassUpdated'] = this.timeStorageClassUpdated;
    data['md5Hash'] = this.md5Hash;
    data['selfLink'] = this.selfLink;
    data['crc32c'] = this.crc32c;
    data['timeCreated'] = this.timeCreated;
    data['etag'] = this.etag;
    data['contentType'] = this.contentType;
    data['id'] = this.id;
    data['storageClass'] = this.storageClass;
    data['name'] = this.name;
    data['generation'] = this.generation;
    data['contentEncoding'] = this.contentEncoding;
    data['kind'] = this.kind;
    data['bucket'] = this.bucket;
    data['size'] = this.size;
    return data;
  }
}