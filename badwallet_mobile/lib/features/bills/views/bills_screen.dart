import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bills_provider.dart';
import 'package:intl/intl.dart';

class BillsScreen extends StatelessWidget {
  const BillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final billsProvider = Provider.of<BillsProvider>(context);
    final factures = billsProvider.factures;
    final isLoading = billsProvider.isLoading;
    final error = billsProvider.error;
    final services = billsProvider.services;

    return Scaffold(
      appBar: AppBar(title: const Text('Factures impayées')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Fournisseur'),
              value: billsProvider.selectedService,
              items: services.map((service) {
                return DropdownMenuItem(value: service, child: Text(service));
              }).toList(),
              onChanged: (value) {
                if (value != null) billsProvider.selectService(value);
              },
            ),
            const SizedBox(height: 16),
            if (isLoading) const Center(child: CircularProgressIndicator()),
            if (error != null) Text(error, style: const TextStyle(color: Colors.red)),
            if (!isLoading && factures.isEmpty && billsProvider.selectedService != null)
              const Text('Aucune facture impayée pour ce fournisseur.'),
            Expanded(
              child: ListView.builder(
                itemCount: factures.length,
                itemBuilder: (context, index) {
                  final facture = factures[index];
                  final isSelected = billsProvider.selectedReferences.contains(facture.reference);
                  return CheckboxListTile(
                    title: Text(facture.reference),
                    subtitle: Text('Échéance: ${DateFormat.yMMMd().format(facture.dueDate)}'),
                    secondary: Text(
                      NumberFormat.currency(locale: 'fr_SN', symbol: 'XOF', decimalDigits: 0).format(facture.amount),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    value: isSelected,
                    onChanged: (_) => billsProvider.toggleSelection(facture),
                  );
                },
              ),
            ),
            if (billsProvider.selectedReferences.isNotEmpty)
              ElevatedButton(
                onPressed: billsProvider.paySelected,
                child: Text('Payer (${billsProvider.selectedReferences.length})'),
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              ),
          ],
        ),
      ),
    );
  }
}