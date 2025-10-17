import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/routes/routes.dart';
import '../bloc/stock_cubit.dart';
import '../bloc/stock_state.dart';

class StockListPage extends StatefulWidget {
  const StockListPage({super.key});

  @override
  State<StockListPage> createState() => _StockListPageState();
}

class _StockListPageState extends State<StockListPage> {
  final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    context.read<StockCubit>().loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Stock Management',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => context.read<StockCubit>().loadProducts(),
          ),
          IconButton(
            icon: const Icon(Icons.assessment_rounded, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, Routes.monthlySummary);
            },
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
                    ElevatedButton(onPressed: () => context.read<StockCubit>().loadProducts(), child: const Text('Retry')),
                  ],
                ),
              );
            }

            if (state is ProductsLoaded) {
              return SafeArea(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    final product = state.products[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.08), spreadRadius: 2, blurRadius: 10, offset: const Offset(0, 2))],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.blue.shade400, Colors.blue.shade600],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.inventory_2_rounded, color: Colors.white),
                        ),
                        title: Text(product.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(product.category, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                            const SizedBox(height: 4),
                            Text(
                              currencyFormatter.format(product.price),
                              style: TextStyle(fontSize: 14, color: Colors.blue.shade700, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            'Stock: ${product.initialStock}',
                            style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, Routes.addTransaction, arguments: product);
                        },
                      ),
                    );
                  },
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
