class Employee {
  String? uid;
  final String name;
  final String email;
  final String department;
  final DateTime joiningDate;
  final String profileImage;
  final String role;
  final String contactNo;

  // Constructor
  Employee({
    this.uid,
    required this.name,
    required this.email,
    required this.department,
    required this.joiningDate,
    required this.profileImage,
    required this.role,
    required this.contactNo,
  });

  // Factory method to create an Employee object from a map
  factory Employee.fromMap(Map<String, dynamic> map) {
    print(map['joiningDate'].toString());
    DateTime dateTime = map['joiningDate'].toDate();

    return Employee(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      department: map['department'],
      joiningDate: dateTime,
      profileImage: map['profileImage'],
      role: map['role'],
      contactNo: map['contactNo'],
    );
  }

  // Method to convert Employee object to a map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'department': department,
      'joiningDate': joiningDate.toIso8601String(),
      'profileImage': profileImage,
      'role': role,
      'contactNo': contactNo,
    };
  }
}
