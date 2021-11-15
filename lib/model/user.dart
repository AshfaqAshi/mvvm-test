
import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class User{
  @HiveField(0)
  String name;
  @HiveField(1)
  String phone;

  @HiveField(2)
  String? uid;

  User({required this.name,required this.phone, this.uid});

}