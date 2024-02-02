import 'dart:io';

import 'package:assignment_bn/models/employee.dart';
import 'package:assignment_bn/services/auth_service.dart';
import 'package:assignment_bn/services/database_service.dart';
import 'package:assignment_bn/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddEmployeeScreen extends StatefulWidget {
  @override
  _AddEmployeeScreenState createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController joiningDateController = TextEditingController();
  // final TextEditingController profileImageController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController contactNoController = TextEditingController();

  File? _image;

  final List<String> roleOptions = [
    "Admin",
    "Manager",
    "HR",
    "Senior Developer",
    "Junior Developer"
  ];

  @override
  void initState() {
    super.initState();

    roleController.text = "Admin";
  }

  final _authMethods = AuthService();
  final _storageMethods = StorageService();
  final _dbMethods = DatabaseService();
  bool isLoading = false;

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _addData() async {
    String uid = await _authMethods.generateUid();

    // Upload image to Firebase Storage
    if (_image == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Image Required")));
      return;
    }
    setState(() {
      isLoading = true;
    });
    String profileImageUrl = await _storageMethods.uploadImage(uid, _image!);

    // Create an Employee object with the validated data, including the image URL
    final Employee newEmployee = Employee(
      uid: uid,
      name: nameController.text,
      email: emailController.text,
      department: departmentController.text,
      joiningDate: DateTime.parse(joiningDateController.text),
      profileImage: profileImageUrl,
      role: roleController.text,
      contactNo: contactNoController.text,
    );

    // Push data to Firestore
    await _dbMethods.pushData(newEmployee);

    // Display the UID (you can store it in a variable as needed)
    print("Generated UID: $uid");
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Data Uploaded")));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Employee'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      _pickImage();
                    },
                    child: _image == null
                        ? const CircleAvatar(
                            child: Icon(Icons.person_2_outlined, size: 40.0),
                            radius: 60.0,
                          )
                        : CircleAvatar(
                            radius: 60,
                            child: ClipOval(
                              child: SizedBox(
                                  width: 120,
                                  height: 120,
                                  child: Image.file(
                                    _image!,
                                    fit: BoxFit.cover,
                                  )),
                            ),
                          ),
                  ),
                ),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                      labelText: 'Name',
                      hintText: 'Enter name (min 6 characters)'),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 6) {
                      return 'Please enter a valid name (at least 6 characters)';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      labelText: 'Email', hintText: 'Enter email'),
                  validator: (value) {
                    final RegExp emailRegex =
                        RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
                    if (value == null ||
                        value.isEmpty ||
                        !emailRegex.hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: departmentController,
                  decoration: const InputDecoration(
                      labelText: 'Department', hintText: 'Enter department'),
                ),
                TextFormField(
                  controller: joiningDateController,
                  decoration: const InputDecoration(
                      labelText: 'Joining Date',
                      hintText: 'Select joining date'),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      joiningDateController.text =
                          pickedDate.toLocal().toString().split(" ")[0];
                    }
                  },
                  readOnly: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a joining date';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: roleController.text,
                  onChanged: (String? value) {
                    setState(() {
                      roleController.text = value!;
                    });
                  },
                  items: roleOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                      labelText: 'Role', hintText: 'Select role'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a role';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: contactNoController,
                  decoration: const InputDecoration(
                      labelText: 'Contact Number',
                      hintText: 'Enter contact number'),
                  validator: (value) {
                    final RegExp phoneRegex = RegExp(r'^\d{10}$');
                    if (value == null ||
                        value.isEmpty ||
                        !phoneRegex.hasMatch(value)) {
                      return 'Please enter a valid 10-digit contact number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                isLoading
                    ? Column(
                      children: [
                        Center(child: CircularProgressIndicator()),
                      ],
                    )
                    : ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _addData();
                          }
                        },
                        child: const Text('Save'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
