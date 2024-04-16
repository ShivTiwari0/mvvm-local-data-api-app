import 'package:flutter/material.dart';
import 'package:geekrabit_project/model/employe_model.dart';
import 'package:geekrabit_project/repositories/auth_repo.dart';

enum EmployeeState {
  loading,
  loaded,
  error,
}

class EmployeeViewModel extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();
  List<Data> _employees = [];
  EmployeeState _state = EmployeeState.loading;
  String _error = '';

  List<Data> get employees => _employees;
  EmployeeState get state => _state;
  String get error => _error;

  Future<void> fetchEmployees() async {
    try {
      _state = EmployeeState.loading;
      notifyListeners();

      _employees = await _repository.getEmployees();
      _state = EmployeeState.loaded;
      notifyListeners();
    } catch (e) {
      _state = EmployeeState.error;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateEmployee(Data employee) async {
    try {
      await _repository.updateEmployee(employee);
      await fetchEmployees();
    } catch (e) {
      throw e;
    }
  }

  Future<void> deleteEmployee(int id) async {
    try {
      await _repository.deleteEmployee(id);
      await fetchEmployees();
    } catch (e) {
      throw e;
    }
  }
}
