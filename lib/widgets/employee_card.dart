import 'package:assignment_bn/models/employee.dart';
import 'package:flutter/material.dart';

class EmployeeCard extends StatelessWidget {
  final Employee employee;

  EmployeeCard({required this.employee});

  @override
  Widget build(BuildContext context) {
    bool isMoreThan5YearsAgo = isDateMoreThan5YearsAgo(employee.joiningDate);
    return ClipRRect(

      borderRadius: BorderRadius.circular(20.0),
      child: Card(
        child: ListTile(
          // selected: isMoreThan5YearsAgo,
          // selectedTileColor: Colors.green,

          tileColor: isMoreThan5YearsAgo ? Colors.green : null,
          textColor:  isMoreThan5YearsAgo ? Colors.white : null,

          leading: CircleAvatar(
            backgroundImage: NetworkImage(employee.profileImage),
          ),
          title: Text(employee.name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text("Email: ${employee.email}"),
              Text("Department: ${employee.department}"),
              Text("Joining Date: ${employee.joiningDate.toLocal().toString().split(" ")[0]}"),
              Text("Role: ${employee.role}"),
            ],
          ),
        ),
      ),
    );
  }
  bool isDateMoreThan5YearsAgo(DateTime joiningDate) {
    DateTime currentDate = DateTime.now();
    Duration difference = currentDate.difference(joiningDate);

    // Check if the difference is more than 5 years (365 days * 5)
    return difference.inDays > (365 * 5);
  }
}
