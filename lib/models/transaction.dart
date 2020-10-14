import 'package:flutter/material.dart';
import 'dart:convert';

List<Transaction> txFromJson(String str) =>
    List<Transaction>.from(json.decode(str).map((x) => Transaction.fromJson(x)));

String txToJson(List<Transaction> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


class Transaction {
  final int id;
  final String title;
  final double amount;
  final DateTime date;
  final String expense;

  Transaction({
    @required this.id,
    @required this.title,
    @required this.amount,
    @required this.date,
    this.expense = 'true',
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json["id"],
        title: json["title"],
        amount: json["amount"],
        date: json["date"],
        expense: json["expense"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "amount": amount,
        "date": date.millisecondsSinceEpoch.toString(),
        "expense": expense
      };
}

