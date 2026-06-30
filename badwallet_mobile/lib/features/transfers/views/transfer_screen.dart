import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transfer_provider.dart';

class TransferScreen extends StatelessWidget {
  const TransferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transferProvider = Provider.of<TransferProvider>(context);
    final isLoading = transferProvider.isLoading;
    final error = transferProvider.error;
    final success = transferProvider.success;

    return Scaffold(
      appBar: AppBar(title: const Text('Transfert d\'argent')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: transferProvider.formKey,
          child: Column(
            children: [
              TextFormField(
                controller: transferProvider.destinationController,
                decoration: const InputDecoration(
                  labelText: 'Numéro destinataire',
                  hintText: '+221770000002',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Requis';
                  if (!value.startsWith('+221')) return 'Format invalide';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: transferProvider.amountController,
                decoration: const InputDecoration(
                  labelText: 'Montant (XOF)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Requis';
                  if (double.tryParse(value) == null) return 'Nombre invalide';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              if (isLoading) const CircularProgressIndicator(),
              if (error != null) Text(error, style: const TextStyle(color: Colors.red)),
              if (success) const Text('Transfert réussi !', style: TextStyle(color: Colors.green)),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : () => transferProvider.transfer(),
                  child: const Text('Transférer'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}