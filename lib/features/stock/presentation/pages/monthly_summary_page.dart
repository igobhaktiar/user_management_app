import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/stock_cubit.dart';
import '../bloc/stock_state.dart';

class MonthlySummaryPage extends StatefulWidget {
  const MonthlySummaryPage({super.key});

  @override
  State<MonthlySummaryPage> createState() => _MonthlySummaryPageState();
}

class _MonthlySummaryPageState extends State<MonthlySummaryPage> {
  DateTime _selectedMonth = DateTime.now();
  final dateFormatter = DateFormat('MMMM yyyy');

  @override
  void initState() {
    super.initState();
    context.read<StockCubit>().loadMonthlySummary(_selectedMonth);
  }

  void _selectMonth() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _selectedMonth,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
    );

    if (selected != null) {
      setState(() {
        _selectedMonth = DateTime(selected.year, selected.month, 1);
      });
      // ignore: use_build_context_synchronously
      context.read<StockCubit>().loadMonthlySummary(_selectedMonth);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        context.read<StockCubit>().loadProducts();
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.blue.shade800, Colors.blue.shade600]),
            ),
          ),
          title: const Text(
            'Monthly Summary',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.calendar_month, color: Colors.white),
              onPressed: _selectMonth,
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            image: const DecorationImage(
              image: NetworkImage('https://transparenttextures.com/patterns/subtle-white-feathers.png'),
              repeat: ImageRepeat.repeat,
              opacity: 0.5,
            ),
          ),
          child: BlocBuilder<StockCubit, StockState>(
            builder: (context, state) {
              if (state is StockLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is StockError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 60),
                      const SizedBox(height: 16),
                      Text(state.message, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 16),
                      ElevatedButton(onPressed: () => context.read<StockCubit>().loadMonthlySummary(_selectedMonth), child: const Text('Retry')),
                    ],
                  ),
                );
              }

              if (state is MonthlySummaryLoaded) {
                final summaries = state.summaries;

                // Calculate totals
                int totalInitialStock = 0;
                int totalPurchase = 0;
                int totalSale = 0;
                int totalCurrentStock = 0;

                for (var summary in summaries) {
                  totalInitialStock += summary.initialStock;
                  totalPurchase += summary.totalPurchase;
                  totalSale += summary.totalSale;
                  totalCurrentStock += summary.currentStock;
                }

                return SafeArea(
                  child: Column(
                    children: [
                      // Month Header
                      Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.blue.shade600, Colors.blue.shade800],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(color: Colors.blue.shade300.withOpacity(0.3), spreadRadius: 2, blurRadius: 10, offset: const Offset(0, 2)),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              dateFormatter.format(_selectedMonth),
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStatItem('Initial', totalInitialStock, Icons.inventory_2_rounded),
                                _buildStatItem('Purchase', totalPurchase, Icons.arrow_downward_rounded),
                                _buildStatItem('Sale', totalSale, Icons.arrow_upward_rounded),
                                _buildStatItem('Current', totalCurrentStock, Icons.warehouse_rounded),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Products Summary List
                      Expanded(
                        child: summaries.isEmpty
                            ? const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.inventory_outlined, size: 48, color: Colors.grey),
                                    SizedBox(height: 16),
                                    Text('No data available', style: TextStyle(fontSize: 16, color: Colors.grey)),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: summaries.length,
                                itemBuilder: (context, index) {
                                  final summary = summaries[index];
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(color: Colors.grey.withOpacity(0.08), spreadRadius: 2, blurRadius: 10, offset: const Offset(0, 2)),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(summary.productName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                          const SizedBox(height: 12),
                                          Row(
                                            children: [
                                              Expanded(child: _buildSummaryItem('Initial', summary.initialStock, Colors.grey)),
                                              Expanded(child: _buildSummaryItem('Purchase', summary.totalPurchase, Colors.blue)),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Expanded(child: _buildSummaryItem('Sale', summary.totalSale, Colors.orange)),
                                              Expanded(child: _buildSummaryItem('Current', summary.currentStock, Colors.green)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, int value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(height: 4),
        Text(
          value.toString(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.white70)),
      ],
    );
  }

  Widget _buildSummaryItem(String label, int value, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(color: color.shade50, borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: color.shade700)),
          const SizedBox(height: 4),
          Text(
            value.toString(),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color.shade700),
          ),
        ],
      ),
    );
  }
}
