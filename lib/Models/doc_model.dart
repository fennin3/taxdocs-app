class SentDoc {
  String? note;
  String? userId;
  FileData? fileData;
  String? hash;
  int? createdOn;
  String? fileName;
  String? id;
  int? modifiedOn;

  SentDoc(
      {this.note,
        this.userId,
        this.fileData,
        this.hash,
        this.createdOn,
        this.fileName,
        this.id,
        this.modifiedOn});

  SentDoc.fromJson(Map<String, dynamic> json) {
    note = json['note'];
    userId = json['userId'];
    fileData = json['fileData'] != null
        ? FileData.fromJson(json['fileData'])
        : null;
    hash = json['hash'];
    createdOn = json['createdOn'];
    fileName = json['fileName'];
    id = json['id'];
    modifiedOn = json['modifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['note'] = this.note;
    data['userId'] = this.userId;
    if (this.fileData != null) {
      data['fileData'] = this.fileData!.toJson();
    }
    data['hash'] = this.hash;
    data['createdOn'] = this.createdOn;
    data['fileName'] = this.fileName;
    data['id'] = this.id;
    data['modifiedOn'] = this.modifiedOn;
    return data;
  }
}

class FileData {
  String? cacheControl;
  String? storageClass;
  String? contentEncoding;
  String? bucket;
  String? generation;
  String? contentType;
  String? metageneration;
  String? selfLink;
  String? timeStorageClassUpdated;
  String? mediaLink;
  String? etag;
  String? id;
  String? timeCreated;
  String? updated;
  String? crc32c;
  String? name;
  String? kind;
  String? md5Hash;

  FileData(
      {this.cacheControl,
        this.storageClass,
        this.contentEncoding,
        this.bucket,
        this.generation,
        this.contentType,
        this.metageneration,
        this.selfLink,
        this.timeStorageClassUpdated,
        this.mediaLink,
        this.etag,
        this.id,
        this.timeCreated,
        this.updated,
        this.crc32c,
        this.name,
        this.kind,
        this.md5Hash});

  FileData.fromJson(Map<String, dynamic> json) {
    cacheControl = json['cacheControl'];
    storageClass = json['storageClass'];
    contentEncoding = json['contentEncoding'];
    bucket = json['bucket'];
    generation = json['generation'];
    contentType = json['contentType'];
    metageneration = json['metageneration'];
    selfLink = json['selfLink'];
    timeStorageClassUpdated = json['timeStorageClassUpdated'];
    mediaLink = json['mediaLink'];
    etag = json['etag'];
    id = json['id'];
    timeCreated = json['timeCreated'];
    updated = json['updated'];
    crc32c = json['crc32c'];
    name = json['name'];
    kind = json['kind'];
    md5Hash = json['md5Hash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cacheControl'] = this.cacheControl;
    data['storageClass'] = this.storageClass;
    data['contentEncoding'] = this.contentEncoding;
    data['bucket'] = this.bucket;
    data['generation'] = this.generation;
    data['contentType'] = this.contentType;
    data['metageneration'] = this.metageneration;
    data['selfLink'] = this.selfLink;
    data['timeStorageClassUpdated'] = this.timeStorageClassUpdated;
    data['mediaLink'] = this.mediaLink;
    data['etag'] = this.etag;
    data['id'] = this.id;
    data['timeCreated'] = this.timeCreated;
    data['updated'] = this.updated;
    data['crc32c'] = this.crc32c;
    data['name'] = this.name;
    data['kind'] = this.kind;
    data['md5Hash'] = this.md5Hash;
    return data;
  }
}