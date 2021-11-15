import 'package:flutter/material.dart';
import 'package:technical_test/view_model/medicine_view_model.dart';

class MedicineItem extends StatelessWidget {
  final MedicineViewModel medicine;
  MedicineItem(this.medicine);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${medicine.name} (${medicine.className})',),
      subtitle: Text('Dose: ${medicine.dose}  Strength: ${medicine.strength} '),
    );
  }
}
