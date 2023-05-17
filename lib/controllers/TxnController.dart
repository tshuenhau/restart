import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:restart/env.dart';
import 'package:restart/models/TransactionModel.dart';
import 'dart:convert';
import 'package:restart/controllers/AuthController.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class TxnController extends GetxController {
  AuthController auth = Get.find();
  RxBool hasInitialised = RxBool(false);

  RxList<TransactionModel> completedTxns = RxList();
  RxList<TransactionModel> upcomingTxns = RxList();
  RxList<TransactionModel> rejectedTxns = RxList();

  @override
  onInit() async {
    super.onInit();
    EasyLoading.show(status: 'loading...');
    await getTxns();
    EasyLoading.dismiss();
  }

  createTxn(String seller, String location, DateTime date) async {
    var response =
        await http.post(Uri.parse('$API_URL/transactions'), headers: {
      'Authorization': 'Bearer ${auth.tk}',
    }, body: {
      "seller": seller,
      "collector": "",
      "location": location,
      "date": date.toString(),
    });
    if (response.statusCode == 200) {
      await getTxns();
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  getTxns() async {
    hasInitialised.value = false;
    upcomingTxns.clear();
    completedTxns.clear();
    rejectedTxns.clear();
    var response = await http.get(
      Uri.parse('$API_URL/transactions/seller=${auth.user.value!.id}'),
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
    hasInitialised.value = true;

    print('compelted txns ' + completedTxns.toString());
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
    var response = await http.get(
      Uri.parse('$API_URL/transactions/collector=${auth.user.value!.id}'),
      headers: {
        'Authorization': 'Bearer ${auth.tk}',
      },
    );
    if (response.statusCode == 200) {
      upcomingTxns.clear();
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
    EasyLoading.show(status: 'loading...');
    var response = await http.put(
      Uri.parse('$API_URL/transactions/id=$id/cancel'),
      headers: {
        'Authorization': 'Bearer ${auth.tk}',
      },
    );
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Transaction cancelled!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      upcomingTxns.removeWhere((t) => t.id == txn.id);
      await getTxns();
      EasyLoading.dismiss();
      return response.body;
    } else {
      EasyLoading.dismiss();

      Fluttertoast.showToast(
          msg: "Unable to cancel transaction!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16.0);
      return null;
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
