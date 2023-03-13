import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:restart/env.dart';
import 'package:restart/models/TransactionModel.dart';
import 'dart:convert';
import 'package:restart/controllers/AuthController.dart';

class TxnController extends GetxController {
  AuthController auth = Get.find();
  Rx<bool> hasInitialised = RxBool(false);
  RxList<TransactionModel> completedTxns = RxList();
  RxList<TransactionModel> upcomingTxns = RxList();
  RxList<TransactionModel> rejectedTxns = RxList();
  @override
  onInit() async {
    super.onInit();
    await getTxns();
    print(upcomingTxns);
    print(completedTxns);
    hasInitialised.value = true;
  }

  getTxns() async {
    upcomingTxns.clear();
    completedTxns.clear();
    rejectedTxns.clear();
    var response = await http.get(
      Uri.parse('$API_URL/transactions/collector=${auth.user.value!.id}'),
      headers: {
        'Authorization': 'Bearer ${auth.tk}',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      //get timeslot
      for (int i = 0; i < body.length; i++) {
        TransactionModel txn = TransactionModel.fromJson(body[i]);
        if (txn.status == TXN_STATUS.COMPLETED) {
          completedTxns.add(txn);
        } else if (txn.status == TXN_STATUS.INCOMPLETE) {
          upcomingTxns.add(txn);
        } else if (txn.status == TXN_STATUS.REJECTED) {
          rejectedTxns.add(txn);
        }
      }
    }
  }

  getCompletedTxn() async {
    completedTxns.clear();
    var response = await http.get(
      Uri.parse('$API_URL/transactions/completed/${auth.user.value!.id}'),
      headers: {
        'Authorization': 'Bearer ${auth.tk}',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      for (int i = 0; i < body.length; i++) {
        TransactionModel txn = TransactionModel.fromJson(body[i]);
        completedTxns.add(txn);
      }
    }
  }

  getRejectedTxn() async {
    rejectedTxns.clear();
    var response = await http.get(
      Uri.parse('$API_URL/transactions/rejected/${auth.user.value!.id}'),
      headers: {
        'Authorization': 'Bearer ${auth.tk}',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      for (int i = 0; i < body.length; i++) {
        TransactionModel txn = TransactionModel.fromJson(body[i]);
        rejectedTxns.add(txn);
      }
    }
  }

  getUpcomingTxns() async {
    upcomingTxns.clear();
    var response = await http.get(
      Uri.parse('$API_URL/transactions/collector=${auth.user.value!.id}'),
      headers: {
        'Authorization': 'Bearer ${auth.tk}',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      for (int i = 0; i < body.length; i++) {
        TransactionModel txn = TransactionModel.fromJson(body[i]);
        if (txn.status == TXN_STATUS.INCOMPLETE) {
          upcomingTxns.add(txn);
        }
      }
    }
  }

  completeTxn(TransactionModel txn, double weight) async {
    String id = txn.id;
    var response = await http
        .put(Uri.parse('$API_URL/transactions/id=$id/complete'), headers: {
      'Authorization': 'Bearer ${auth.tk}',
    }, body: {
      'weight': weight.toString(),
    });
    if (response.statusCode == 200) {
      return response.body;
    } else {
      response.printError();
      throw Exception('error ' + response.statusCode.toString());
    }
  }

  cancelTxn(TransactionModel txn) async {
    String id = txn.id;
    var response = await http.put(
      Uri.parse('$API_URL/transactions/id=$id/cancel'),
      headers: {
        'Authorization': 'Bearer ${auth.tk}',
      },
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Error cancelling transaction! Try again.');
    }
  }

  rejectTxn(TransactionModel txn) async {
    String id = txn.id;
    var response = await http.put(
      Uri.parse('$API_URL/transactions/id=$id/reject'),
      headers: {
        'Authorization': 'Bearer ${auth.tk}',
      },
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Error rejecting transaction! Try again.');
    }
  }
}
