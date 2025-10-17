import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/stock_transaction.dart';
import '../bloc/stock_cubit.dart';

class AddTransactionPage extends StatefulWidget {
  final dynamic product;

  const AddTransactionPage({super.key, required this.product});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  String _selectedType = 'sale';
  bool _isProcessing = false;
  final _uuid = const Uuid();

  Product get product => widget.product as Product;

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isProcessing = true);

      try {
        final transaction = StockTransaction(
          id: _uuid.v4(),
          productId: product.id,
          productName: product.name,
          quantity: int.parse(_quantityController.text),
          date: DateTime.now(),
          type: _selectedType,
        );

        await context.read<StockCubit>().addNewTransaction(transaction);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Transaction added successfully!'), backgroundColor: Colors.green));
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
        }
      } finally {
        if (mounted) {
          setState(() => _isProcessing = false);
        }
      }
    }
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
          'Add Transaction',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade800.withOpacity(0.05), Colors.grey.shade50],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Product Info Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.08), spreadRadius: 2, blurRadius: 10, offset: const Offset(0, 2))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [Colors.blue.shade400, Colors.blue.shade600]),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.inventory_2_rounded, color: Colors.white),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(product.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 4),
                                    Text(product.category, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Current Stock', style: TextStyle(color: Colors.grey.shade700)),
                                Text(
                                  '${product.initialStock} units',
                                  style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Quantity Field
                    TextFormField(
                      controller: _quantityController,
                      decoration: InputDecoration(
                        labelText: 'Quantity',
                        hintText: 'Enter quantity',
                        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15),
                        prefixIcon: Icon(Icons.numbers_rounded, color: Colors.blue.shade400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.blue.shade400),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      ),
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter quantity';
                        }
                        final quantity = int.tryParse(value);
                        if (quantity == null || quantity <= 0) {
                          return 'Please enter a valid quantity';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Transaction Type
                    const Padding(
                      padding: EdgeInsets.fromLTRB(8, 0, 8, 12),
                      child: Text(
                        'Transaction Type',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedType = 'purchase'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: _selectedType == 'purchase' ? Colors.blue.shade50 : Colors.white,
                                border: Border.all(color: _selectedType == 'purchase' ? Colors.blue.shade400 : Colors.grey.shade200),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.arrow_downward_rounded,
                                    color: _selectedType == 'purchase' ? Colors.blue.shade400 : Colors.grey.shade400,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Purchase',
                                    style: TextStyle(
                                      color: _selectedType == 'purchase' ? Colors.blue.shade700 : Colors.grey.shade600,
                                      fontWeight: _selectedType == 'purchase' ? FontWeight.w600 : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedType = 'sale'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: _selectedType == 'sale' ? Colors.orange.shade50 : Colors.white,
                                border: Border.all(color: _selectedType == 'sale' ? Colors.orange.shade400 : Colors.grey.shade200),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.arrow_upward_rounded, color: _selectedType == 'sale' ? Colors.orange.shade400 : Colors.grey.shade400),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Sale',
                                    style: TextStyle(
                                      color: _selectedType == 'sale' ? Colors.orange.shade700 : Colors.grey.shade600,
                                      fontWeight: _selectedType == 'sale' ? FontWeight.w600 : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isProcessing ? null : _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade600,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: _isProcessing
                            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Text('Add Transaction', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
