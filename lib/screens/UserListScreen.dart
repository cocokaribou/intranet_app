import 'package:flutter/material.dart';

import '../models/Employee.dart';
import '../services/api_service.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Employee>>(
      future: ApiService().fetchEmployees(), // Ensure ApiService is properly implemented
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show loading indicator
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else {
          // Data loaded
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Employee employee = snapshot.data![index];
              return ListTile(
                leading: Image.network(employee.image), // Placeholder for employee image
                title: Text(employee.name),
                subtitle: Text('${employee.position}, ${employee.department}'),
              );
            },
          );
        }
      },
    );
  }
}