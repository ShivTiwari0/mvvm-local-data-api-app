// auth_repository.dart
import 'package:geekrabit_project/data/local_database/database_helper.dart';

import 'package:geekrabit_project/data/network/base_apiservice.dart';

import 'package:geekrabit_project/data/network/networkapi_services.dart';
import 'package:geekrabit_project/model/employe_model.dart';

class AuthRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<List<Data>> getEmployees() async {
    try {
      final List<Data> localEmployees =
          await DatabaseHelper.instance.retrieveEmployees();

      if (localEmployees.isEmpty) {
        var response = await _apiServices.getGetApiResponse(
            'https://dummy.restapiexample.com/api/v1/employees');
        print('API Response: $response');
        EmpolyeModel employe = EmpolyeModel.fromJson(response);
        print('???????${employe.message}');
        await DatabaseHelper.instance.insertEmployees(employe.data!);

        return employe.data!;
      } else {
        print(localEmployees);
        return localEmployees;
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateEmployee(Data employee) async {
    try {
      await DatabaseHelper.instance.updateEmployee(employee);
    } catch (e) {
      throw e;
    }
  }

  Future<void> deleteEmployee(int id) async {
    try {
      await DatabaseHelper.instance.deleteEmployee(id);
    } catch (e) {
      throw e;
    }
  }
}
