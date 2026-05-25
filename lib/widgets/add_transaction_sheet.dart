import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';
import '../providers/finance_provider.dart';
import 'package:flutter_haiku/providers/theme_provider.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'glass_container.dart';

class AddTransactionSheet extends StatefulWidget {
  const AddTransactionSheet({super.key});

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  String _type = 'expense';
  String _category = 'Misc';
  final _noteCtrl = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FinanceProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final palette = themeProvider.palette;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: GlassContainer(
        color: isDark ? palette.cardDark : palette.cardLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.black12,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'New Flow',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SegmentedButton<String>(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.selected)) {
                        return _type == 'expense'
                            ? palette.expense.withOpacity(0.15)
                            : palette.income.withOpacity(0.15);
                      }
                      return Colors.transparent;
                    },
                  ),
                ),
                segments: const [
                  ButtonSegment(value: 'expense', label: Text('Expense')),
                  ButtonSegment(value: 'income', label: Text('Income')),
                ],
                selected: {_type},
                onSelectionChanged: (val) => setState(() => _type = val.first),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _amountCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: '0.00',
                  border: InputBorder.none,
                  prefixText: '\$ ',
                  prefixStyle: GoogleFonts.inter(
                    fontSize: 48,
                    fontWeight: FontWeight.w300,
                    color: _type == 'expense' ? palette.expense : palette.income,
                  ),
                ),
                style: GoogleFonts.inter(
                  fontSize: 48,
                  fontWeight: FontWeight.w600,
                  color: _type == 'expense' ? palette.expense : palette.income,
                ),
                validator: (v) => (v == null || v.isEmpty) ? 'Enter amount' : null,
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: palette.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.category_outlined, color: palette.primary),
                ),
                title: Text(
                  _category,
                  style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () async {
                  final newCat = await showDialog<String>(
                    context: context,
                    builder: (_) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      title: Text('Select Category', style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.w600)),
                      content: SizedBox(
                        width: double.maxFinite,
                        child: ListView(
                          shrinkWrap: true,
                          children: provider.categories.map((c) => ListTile(
                            title: Text(c.name, style: GoogleFonts.inter()),
                            onTap: () => Navigator.of(context).pop(c.name),
                          )).toList(),
                        ),
                      ),
                    ),
                  );
                  if (newCat != null) {
                    setState(() => _category = newCat);
                  }
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: palette.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.calendar_today_outlined, color: palette.primary),
                ),
                title: Text(
                  DateFormat.yMMMd().format(_selectedDate),
                  style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () async {
                  final newDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: isDark
                            ? ColorScheme.dark(primary: palette.primary, onPrimary: Colors.white, surface: palette.cardDark, onSurface: Colors.white)
                            : ColorScheme.light(primary: palette.primary, onPrimary: Colors.white, surface: palette.cardLight, onSurface: Colors.black),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (newDate != null) {
                    setState(() => _selectedDate = newDate);
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noteCtrl,
                decoration: InputDecoration(
                  labelText: 'Add a note (Optional)',
                  labelStyle: GoogleFonts.inter(color: isDark ? Colors.white54 : Colors.black45),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.black12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: isDark ? Colors.white12 : Colors.black12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: palette.primary),
                  ),
                ),
                style: GoogleFonts.inter(),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: palette.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;
                  final amount = double.tryParse(_amountCtrl.text) ?? 0.0;
                  final tx = TransactionModel(
                    amount: amount,
                    category: _category,
                    type: _type,
                    note: _noteCtrl.text,
                    date: _selectedDate.millisecondsSinceEpoch,
                  );
                  provider.addTransaction(tx);
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Record Flow',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
