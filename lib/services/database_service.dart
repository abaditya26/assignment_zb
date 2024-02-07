import 'package:assignment_bn/models/employee.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final _db = FirebaseFirestore.instance;

  Future<void> pushData(Employee newEmployee) async {
    await _db.collection('employees').add({
      'uid': newEmployee.uid,
      'name': newEmployee.name,
      'email': newEmployee.email,
      'department': newEmployee.department,
      'joiningDate': newEmployee.joiningDate,
      'profileImage': newEmployee.profileImage,
      'role': newEmployee.role,
      'contactNo': newEmployee.contactNo,
    });
  }

  Stream<QuerySnapshot> getEmployeesStream() {
    final CollectionReference _employeesCollection =
        FirebaseFirestore.instance.collection('employees');
    return _employeesCollection.snapshots();
  }

  //delete operation
  Future<void> deleteData(String id) async {
    return await _db.collection("employees").doc(id).delete();
  }
}
