import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:technical_test/model/result.dart';
import 'package:technical_test/services/api_service.dart';
import 'package:technical_test/view_model/medicine_list_view_model.dart';

import 'api_service_test.mocks.dart';

@GenerateMocks([ApiService])
void main(){

  group('Test ApiService',(){
    var apiService = MockApiService();

    test('Api returns failed Result in case of error',()async{
      when(apiService.getMedicines()).thenAnswer((realInvocation) async=> Result(userMessage: 'An error occurred'));

      var result = await apiService.getMedicines();
      expect(result.userMessage!=null,true );
    });

    test('Api returns success Result in case fetching completes successfully',()async{
      when(apiService.getMedicines()).thenAnswer((realInvocation) async=> Result(value: {'problems':{}}));

      var result = await apiService.getMedicines();
      expect(result.value!=null,true );
    });

    test('Fetch real data and ensure [medicinesResult] is populated',()async{
      var viewModel = MedicineListViewModel();
      await viewModel.getMedicinesList();
      expect(viewModel.medicinesResult!.success,true);
    });
  });
}