import 'package:flutter/material.dart';
import 'package:geekrabit_project/utils/colors.dart';
import 'package:geekrabit_project/model/employe_model.dart';
import 'package:geekrabit_project/view_model/employee_viewmodel.dart';
import 'package:provider/provider.dart';

class MyHomeScreen extends StatefulWidget {
  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<EmployeeViewModel>(context, listen: false).fetchEmployees();
    });
  }

  @override
  Widget build(BuildContext context) {
    final employeeViewModel = Provider.of<EmployeeViewModel>(context);

    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(
        backgroundColor: (black.withOpacity(0.8)),
        title: Text(
          'Employee List',
          style: TextStyle(color: Colors.grey[300]),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 34, 33, 33), // Light Black
              Colors.grey[200]!, // Light White
            ],
          ),
        ),
        child: _buildEmployeeList(employeeViewModel),
      ),
    );
  }

  Widget _buildEmployeeList(EmployeeViewModel employeeViewModel) {
    switch (employeeViewModel.state) {
      case EmployeeState.loading:
        return const Center(
          child: CircularProgressIndicator(),
        );
      case EmployeeState.loaded:
        return ListView.builder(
          itemCount: employeeViewModel.employees.length,
          itemBuilder: (context, index) {
            final employee = employeeViewModel.employees[index];
            print('view:::::::::::::::${employee.employeeName}');
            return Card(
              color: mustard.withOpacity(0.5),
              child: ListTile(
                leading: CircleAvatar(
                    backgroundImage: NetworkImage(employee.profileImage!)),
                title: Text(
                  employee.employeeName ?? '',
                  style: const TextStyle(
                    color: black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                    'Salary: ${employee.employeeSalary ?? ''}, Age: ${employee.employeeAge ?? ''}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: black),
                      onPressed: () {
                        _updateEmployee(context, employee);
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: black,
                      ),
                      onPressed: () {
                        _deleteEmployee(context, employee.id!);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      case EmployeeState.error:
        return Center(
          child: Text('Error: ${employeeViewModel.error}'),
        );
      default:
        return Container();
    }
  }

  void _updateEmployee(BuildContext context, Data employee) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newName = employee.employeeName ?? '';
        int newSalary = employee.employeeSalary ?? 0;
        int newAge = employee.employeeAge ?? 0;

        return AlertDialog(
          title: const Text('Update Employee'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Name'),
                  onChanged: (value) {
                    newName = value;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Salary'),
                  onChanged: (value) {
                    newSalary = int.tryParse(value) ?? 0;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Age'),
                  onChanged: (value) {
                    newAge = int.tryParse(value) ?? 0;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Data updatedEmployee = Data(
                  id: employee.id,
                  employeeName: newName,
                  employeeSalary: newSalary,
                  employeeAge: newAge,
                  profileImage: employee.profileImage,
                );
                Provider.of<EmployeeViewModel>(context, listen: false)
                    .updateEmployee(updatedEmployee);
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _deleteEmployee(BuildContext context, int id) {
    Provider.of<EmployeeViewModel>(context, listen: false).deleteEmployee(id);
  }
}
