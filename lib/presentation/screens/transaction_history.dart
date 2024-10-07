
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:students/presentation/utils/check_bal.dart';
import 'package:students/utils/constants.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  PaymentHistoryScreenState createState() => PaymentHistoryScreenState();
}

class PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  List<Transaction> transactions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    final phoneNumber = await WalletService.getPhoneNumber();
    final response = await http.get(Uri.parse(
        '${Constants.baseUrl}wallettransaction.php?API-Key=${Constants.apiKey}&phone=$phoneNumber'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        transactions = (jsonData['data'] as List)
            .map((item) => Transaction.fromJson(item))
            .toList();
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load transactions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Payment History',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: isLoading
          ? buildShimmerLoader()
          : transactions.isEmpty? const EmptyStateWidget()
      : ListView.separated(
        itemCount: transactions.length,
        separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey[300]),
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return TransactionTile(transaction: transaction);
        },
      ),
    );
  }
}

class TransactionTile extends StatelessWidget {
  final Transaction transaction;

  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isCredit = transaction.amount.startsWith('+');
    final color = isCredit ? Colors.green : Colors.red;
    final iconData = isCredit ? Icons.add_circle_outline : Icons.remove_circle_outline;

    return Container(
      color: Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Icon(
          iconData,
          color: color,
          size: 28,
        ),
        title: Row(
          children: [
            Text(
              isCredit ? 'Received' : 'Spent',
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  fontSize: 16,
                ),
              ),
            ),
            const Spacer(),
            Text(
              '₹ ${transaction.amount.replaceAll(RegExp(r'[+-]'), '')}',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: color,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              DateFormat('MMM dd, yyyy • HH:mm').format(transaction.date),
              style: GoogleFonts.roboto(
                textStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Ref: ${transaction.reference}',
              style: GoogleFonts.roboto(
                textStyle: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
Widget buildShimmerLoader() {
  return ListView.builder(
    itemCount: 8,  // The number of shimmer items
    itemBuilder: (context, index) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Container(
            color: Colors.white,
            child: ListTile(
              leading: Container(
                width: 28,
                height: 28,
                color: Colors.grey[400],
              ),
              title: Container(
                width: double.infinity,
                height: 16,
                color: Colors.grey[400],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Container(
                    width: 100,
                    height: 12,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}


class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_wallet,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Transactions Yet',
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your payment history will appear here',
            style: GoogleFonts.roboto(
              textStyle: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }


}
class Transaction {
  final DateTime date;
  final String reference;
  final String amount;

  Transaction({required this.date, required this.reference, required this.amount});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      date: DateTime.parse(json['transactiondate']),
      reference: json['paymentreference'],
      amount: json['amount'],
    );
  }
}