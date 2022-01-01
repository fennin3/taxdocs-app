import 'dart:convert';

import 'package:taxdocs/Data/share_pref_data.dart';
import 'package:http/http.dart' as http;
import 'package:taxdocs/Models/archive.dart';
import 'package:taxdocs/Models/doc_model.dart';
import 'package:taxdocs/Models/notification_model.dart';
import 'package:taxdocs/Models/reeceived_doc.dart';
import 'package:taxdocs/Models/setting_model.dart';
import 'package:taxdocs/Models/user_model.dart';
import 'package:taxdocs/constant.dart';


class ApiRequests{

  static Future<UserModel?> getUserDetails()async{
    UserModel? user;
    final token = await SharedData.getToken();
    final uid = await SharedData.getId();
    final url = baseUrl + "user/$uid";
    http.Response response = await http.get(Uri.parse(url),
    headers: {apiTokenKey:token.toString()});

    if(response.statusCode == 200){
      user = UserModel.fromJson(json.decode(response.body)['data']);
    }
    else{
    }
    return user;
  }

  static Future<List<SentDoc>?> getSentDocs()async{
    List<SentDoc> docs = [];
    final token = await SharedData.getToken();
    final uid = await SharedData.getId();
    final url = baseUrl + "documents/$uid/sent";
    // print("-----------");
    // print(uid);
    http.Response response = await http.get(Uri.parse(url),
        headers: {apiTokenKey:token.toString()});

    if(response.statusCode == 200){
      // print("^^^^^^^^^^^-------************");
      List data = json.decode(response.body)['data']['sent'];
      for (var item in data){
        docs.add(SentDoc.fromJson(item));
      }
    }
    else{
      // print("^^^^^^^^^^^-------************");
    }

    return docs;
  }



  static Future<List<ReceivedDoc>?> getReceivedDocs()async{
    List<ReceivedDoc> docs = [];
    final token = await SharedData.getToken();
    final uid = await SharedData.getId();
    final url = baseUrl + "documents/$uid/received";
    http.Response response = await http.get(Uri.parse(url),
        headers: {apiTokenKey:token.toString()});

    if(response.statusCode == 200){
      List data = json.decode(response.body)['data']['received'];
      for (var item in data){
        docs.add(ReceivedDoc.fromJson(item));
      }

    }
    else{
    }
    return docs;
  }

  static Future<List<ArchiveModel>?> getArchivedDocs({required String year, required String month, required String query})async{
    List<ArchiveModel> docs = [];
    final token = await SharedData.getToken();
    final uid = await SharedData.getId();
    final _data = {
      "userId":uid,
      "year":year,
      "month":month,
      "query":query
    };
    const url = "${baseUrl}archive/search";
    http.Response response = await http.post(Uri.parse(url),
        headers: {apiTokenKey:token.toString()}, body: _data);

    if(response.statusCode == 200){
      List data = json.decode(response.body)['data'];
      for (var item in data){
        docs.add(ArchiveModel.fromJson(item));
      }
    }
    else{
    }
    return docs;
  }

  static Future<List<NotificationModel>?> getNotification()async{
    List<NotificationModel> docs = [];
    final token = await SharedData.getToken();
    final uid = await SharedData.getId();
    final url = baseUrl + "notifications/$uid";
    http.Response response = await http.get(Uri.parse(url),
        headers: {apiTokenKey:token.toString()});

    if(response.statusCode == 200){
      List data = json.decode(response.body)['data'];
      for (var item in data){
        docs.add(NotificationModel.fromJson(item));
      }
    }
    else{
    }
    return docs;
  }

  static Future<SettingModel> getSettings()async{
    SettingModel data = SettingModel();
    final token = await SharedData.getToken();
    final uid = await SharedData.getId();

    const url = baseUrl + "settings";
    http.Response response = await http.get(Uri.parse(url),
        headers: {apiTokenKey:token.toString()});

    if(response.statusCode == 200){
      final _data = json.decode(response.body)['data'];
      data = SettingModel.fromJson(_data);
    }
    else{
    }
    return data;
  }

}

//x-tax-token