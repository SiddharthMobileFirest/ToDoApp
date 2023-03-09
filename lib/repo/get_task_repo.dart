// ignore_for_file: non_constant_identifier_names
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/task_model.dart';

class GetAllTaskRepository {
  Future<List<TaskDetailModel>> getAllTaskData(String userId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    List<TaskDetailModel> allTaskList = [];
    try {
      final task = await firestore
          .collection("Users")
          .doc(userId)
          .collection('Task')
          .get();
      // ignore: avoid_function_literals_in_foreach_calls
      task.docs.forEach((element) {
        print(TaskDetailModel.fromJson(element.data()));
        return allTaskList.add(TaskDetailModel.fromJson(element.data()));
      });
      return allTaskList;
    } on FirebaseException {
      return allTaskList;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
