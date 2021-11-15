
import 'package:technical_test/model/medicine.dart';

class MedicineViewModel{
  Medicine medicine;

  MedicineViewModel(this.medicine);

  String get name=>medicine.name;
  String? get dose=>medicine.dose;
  String get strength=>medicine.strength;
  String get className=>medicine.className;
}