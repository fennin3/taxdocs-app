import 'package:hive/hive.dart';

part 'scan_model.g.dart';

@HiveType(typeId: 0)
class ScanModel {
  @HiveField(0)
  String title;

  @HiveField(1)
  String pdf;

  @HiveField(2)
  String userId;

  @HiveField(3)
  DateTime createdAt;

  ScanModel({required this.createdAt, required this.pdf, required this.title, required this.userId});
}