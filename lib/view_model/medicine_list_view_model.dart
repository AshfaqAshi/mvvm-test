
import 'package:flutter/cupertino.dart';
import 'package:technical_test/model/medicine.dart';
import 'package:technical_test/model/result.dart';
import 'package:technical_test/services/api_service.dart';
import 'package:technical_test/view_model/medicine_view_model.dart';

class MedicineListViewModel extends ChangeNotifier{

  Result<List<MedicineViewModel>>? _medicinesResult;

  Result<List<MedicineViewModel>>? get medicinesResult=>_medicinesResult;

  Future<void> getMedicinesList()async{
    Result<Map<String,dynamic>> result = await ApiService.instance.getMedicines();

    if(result.success){
      ///extract medicines list from the json and populate [_medicinesResult]
      ///The medicines list is deeply nested inside the json object.
      ///Loop through each of nested lists and add the medicine item to the [_medicinesResult] list
      var json = result.value!;
      List<MedicineViewModel> _medicineViewModelList=[];
      json['problems'].forEach((problem){
        (problem as Map<String,dynamic>).keys.forEach((key){
          ///get the value by key
          List<dynamic> diseases = problem[key];
          ///Loop further through each of the disease
            diseases.forEach((disease){
              ///get the list of medications
              ///
              //print('disease ${disease}');
              if((disease as Map).isNotEmpty){
                List<dynamic> medications = disease['medications'];
                ///Loop further through each of the medication
                medications.forEach((medication){
                  ///get the list of medicationsClasses
                  List<dynamic> medicationsClasses = medication['medicationsClasses'];
                  ///Loop further through each of the medicationsClasses
                  medicationsClasses.forEach((medicationClass){
                    ///Each [medicationClass] has (n) no of keys which are list of elements.
                    ///Loop through each of these keys to get the nested list of elements for
                    ///further processing.
                    (medicationClass as Map<String,dynamic>).keys.forEach((classNameKey){
                      ///Get the list
                      List<dynamic> associatedDrugList = medicationClass[classNameKey];
                      ///Loop through the list
                      associatedDrugList.forEach((associatedDrug){
                        ///Loop through the keys and get their values
                        (associatedDrug as Map<String,dynamic>).keys.forEach((key){
                          List<dynamic> medicines = associatedDrug[key];
                          ///Loop through each medicine and add to medicines list
                          medicines.forEach((medicine){
                            _medicineViewModelList.add(MedicineViewModel(Medicine.fromJson(medicine, classNameKey)));
                          });
                        });
                      });
                    });
                  });
                });
              }
            });

        });
      });

      _medicinesResult = Result(value: _medicineViewModelList);
      notifyListeners();
    }else{
      _medicinesResult = Result(message: result.message,userMessage: 'An error occurred while fetching '
          'medicines list');
      notifyListeners();
    }
  }
}