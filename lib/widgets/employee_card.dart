import 'package:assignment_bn/models/employee.dart';
import 'package:assignment_bn/services/database_service.dart';
import 'package:flutter/material.dart';

class EmployeeCard extends StatelessWidget {
  final Employee employee;
  final _dbMethods = DatabaseService();

  EmployeeCard({required this.employee});

  @override
  Widget build(BuildContext context) {
    Color color = getColor(employee.joiningDate);
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Card(
        child: ListTile(
          // selected: isMoreThan5YearsAgo,
          // selectedTileColor: Colors.green,

          tileColor: color,
          // textColor: isMoreThan5YearsAgo ? Colors.white : null,

          leading: CircleAvatar(
            backgroundImage: NetworkImage(employee.profileImage),
          ),
          trailing: IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Confirm Delete."),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          _dbMethods.deleteData(employee.uid!);
                          Navigator.of(context).pop();
                        },
                        child: Text("Confirm")),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Cancel")),
                  ],
                ),
              );
            },
            icon: Icon(Icons.delete),
          ),
          title: Text(employee.name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text("Email: ${employee.email}"),
              Text("Department: ${employee.department}"),
              Text(
                  "Joining Date: ${employee.joiningDate.toLocal().toString().split(" ")[0]}"),
              Text("Role: ${employee.role}"),
            ],
          ),
        ),
      ),
    );
  }

  Color getColor(DateTime joiningDate) {
    DateTime currentDate = DateTime.now();
    Duration difference = currentDate.difference(joiningDate);
    // Check if the difference is more than 5 years (365 days * 5)
    return difference.inDays > (365 * 5)
        ? Colors.green
        : difference.inDays > (365 * 2)
            ? Colors.purple
            : Colors.blue;
  }
}

//
