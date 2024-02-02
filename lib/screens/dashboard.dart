import 'package:assignment_bn/models/employee.dart';
import 'package:assignment_bn/screens/add_employee.dart';
import 'package:assignment_bn/services/database_service.dart';
import 'package:assignment_bn/widgets/employee_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isLoading = false;

  final _db = DatabaseService();

  @override
  void initState() {
    super.initState();
  }

  final List<Employee> employees = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employees"),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text("Aditya Bodhankar"),
              accountEmail: Text("adityaabodhankar@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://adityabodhankar.in/assets/profile.jpeg"),
              ),
              decoration: BoxDecoration(color: Colors.black54),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                // Handle drawer item click
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Add Employee'),
              onTap: () {
                // Handle drawer item click
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddEmployeeScreen()));
              },
            ),
            // Add more drawer items as needed
          ],
        ),
      ),
      // body: Column(
      //   children: [
      //     // Text("Employee Management"),
      //     Expanded(
      //       child: ListView.builder(
      //         itemCount: employees.length,
      //         itemBuilder: (BuildContext context, int index) {
      //           return EmployeeCard(employee: employees[index]);
      //         },
      //       ),
      //     ),
      //   ],
      // ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _db.getEmployeesStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Loading indicator while waiting for data
          }

          // Check if there are no documents in the collection
          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No employees available.'),
            );
          }

          // If there are documents, build the list view
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              var employeeData = snapshot.data!.docs[index].data()
                  as Map<String, dynamic>;
              var employee = Employee.fromMap(employeeData);
              return EmployeeCard(employee: employee);
            },
          );
        },
      ),
    );
  }
}
