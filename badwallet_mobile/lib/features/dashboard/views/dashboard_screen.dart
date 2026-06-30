import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart';
import '../../../core/routes/app_routes.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = Provider.of<DashboardProvider>(context);
    final balance = dashboardProvider.balance;
    final recent = dashboardProvider.recentTransactions;
    final isLoading = dashboardProvider.isLoading;
    final error = dashboardProvider.error;

    return Scaffold(
      appBar: AppBar(
        title: const Text('BadWallet'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => dashboardProvider.refreshDashboard(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => dashboardProvider.refreshDashboard(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Solde disponible', style: TextStyle(fontSize: 16, color: Colors.grey)),
                      if (isLoading)
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(width: 150, height: 40, color: Colors.white),
                        )
                      else if (error != null)
                        Text('Erreur: $error', style: const TextStyle(color: Colors.red))
                      else if (balance != null)
                        Text(
                          NumberFormat.currency(locale: 'fr_SN', symbol: 'XOF', decimalDigits: 0).format(balance),
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(Icons.send, 'Transférer', () => Navigator.pushNamed(context, AppRoutes.transfer)),
                  _buildActionButton(Icons.receipt, 'Payer', () => Navigator.pushNamed(context, AppRoutes.bills)),
                  _buildActionButton(Icons.history, 'Historique', () => Navigator.pushNamed(context, AppRoutes.history)),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Dernières opérations', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else if (error != null)
                Text('Erreur: $error')
              else if (recent.isEmpty)
                const Text('Aucune transaction récente')
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recent.length,
                  itemBuilder: (context, index) {
                    final tx = recent[index];
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.blue[800]),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}