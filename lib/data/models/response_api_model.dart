
enum StatusResponseApi { success, failure }

class ResponseApiModel {
  StatusResponseApi? status;
  String? message;
  dynamic data;

  ResponseApiModel({this.status, this.message = "", this.data});
}

