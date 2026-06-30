import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/history_provider.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final historyProvider = Provider.of<HistoryProvider>(context);
    final transactions = historyProvider.transactions;
    final isLoading = historyProvider.isLoading;
    final error = historyProvider.error;

    return Scaffold(
      appBar: AppBar(title: const Text('Historique')),
      body: RefreshIndicator(
        onRefresh: () => historyProvider.fetchTransactions(),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : error != null
                ? Center(child: Text(error))
                : transactions.isEmpty
                    ? const Center(child: Text('Aucune transaction'))
                    : ListView.builder(
                        itemCount: transactions.length,
                        itemBuilder: (context, index) {
                          final tx = transactions[index];
                          return ListTile(
                            leading: Icon(
                              tx.type == 'DEPOSIT' || tx.type == 'TRANSFER' ? Icons.arrow_downward : Icons.arrow_upward,
                              color: tx.type == 'DEPOSIT' || tx.type == 'TRANSFER' ? Colors.green : Colors.red,
                            ),
                            title: Text(tx.description),
                            subtitle: Text(DateFormat.yMMMd().add_jm().format(tx.date)),
                            trailing: Text(
                              NumberFormat.currency(locale: 'fr_SN', symbol: 'XOF', decimalDigits: 0).format(tx.amount),
                              style: TextStyle(
                                color: tx.type == 'DEPOSIT' || tx.type == 'TRANSFER' ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}