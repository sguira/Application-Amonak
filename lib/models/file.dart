class Files {
  String? destination;
  String? type;
  String? extension;
  String? originalname;
  String? filename;
  int? size;
  String? url;
  String? sId;

  Files(
      {this.destination,
      this.type,
      this.extension,
      this.originalname,
      this.filename,
      this.size,
      this.url,
      this.sId});

  Files.fromJson(Map json) {
    destination = json['destination'];
    type = json['type'];
    extension = json['extension'];
    originalname = json['originalname'];
    filename = json['filename'];
    size = json['size'];
    url = json['url'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['destination'] = destination;
    data['type'] = type;
    data['extension'] = extension;
    data['originalname'] = originalname;
    data['filename'] = filename;
    data['size'] = size;
    data['url'] = url;
    data['_id'] = sId;
    return data;
  }
}