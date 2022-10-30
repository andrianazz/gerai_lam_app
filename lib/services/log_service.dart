import 'package:cloud_firestore/cloud_firestore.dart';

class LogService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void addLog({String? nama, String? desc, Map? data_old, Map? data_new}) {
    CollectionReference tableLog = firestore.collection("logs");
    try {
      tableLog.doc(DateTime.now().toString()).set({
        'name': nama!,
        'desc': desc!,
        'date': DateTime.now(),
        'data_old': data_old!,
        'data_new': data_new!,
      });
    } catch (e) {
      print(e);
    }
  }
}
