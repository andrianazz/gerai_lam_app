import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gerai_lam_app/models/employee_model.dart';

class EmployeeService {
  var employee = FirebaseFirestore.instance.collection('employees');
}
