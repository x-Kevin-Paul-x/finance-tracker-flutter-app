import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';
import '../providers/finance_provider.dart';
import 'package:flutter_haiku/providers/theme_provider.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

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

    final incomeColor = isDark ? const Color(0xFF34D399) : const Color(0xFF059669);
    final expenseColor = isDark ? const Color(0xFFFF6B6B) : const Color(0xFFDC2626);
    final selectedColor = _type == 'expense' ? expenseColor : incomeColor;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1B1411) : const Color(0xFFFFFDF9),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          border: Border.all(
            color: const Color(0xFFD4AF37).withOpacity(0.45),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 24,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4AF37).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'RECORD NEW FLOW',
                style: GoogleFonts.cinzel(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.3,
                  color: isDark ? const Color(0xFFF3E5AB) : const Color(0xFF2B1D18),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // Segmented Button
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _type = 'expense'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _type == 'expense'
                              ? expenseColor.withOpacity(0.2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _type == 'expense' ? expenseColor : const Color(0xFFD4AF37).withOpacity(0.25),
                            width: _type == 'expense' ? 1.5 : 1.0,
                          ),
                        ),
                        child: Text(
                          'EXPENSE',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cinzel(
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                            letterSpacing: 1.1,
                            color: _type == 'expense' ? expenseColor : (isDark ? Colors.white54 : Colors.black54),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _type = 'income'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _type == 'income'
                              ? incomeColor.withOpacity(0.2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _type == 'income' ? incomeColor : const Color(0xFFD4AF37).withOpacity(0.25),
                            width: _type == 'income' ? 1.5 : 1.0,
                          ),
                        ),
                        child: Text(
                          'INCOME',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cinzel(
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                            letterSpacing: 1.1,
                            color: _type == 'income' ? incomeColor : (isDark ? Colors.white54 : Colors.black54),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Rupee Amount input
              TextFormField(
                controller: _amountCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: '0.00',
                  hintStyle: GoogleFonts.plusJakartaSans(color: isDark ? Colors.white24 : Colors.black26),
                  border: InputBorder.none,
                  prefixText: '₹ ',
                  prefixStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 42,
                    fontWeight: FontWeight.w700,
                    color: selectedColor,
                  ),
                ),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  color: selectedColor,
                ),
                validator: (v) => (v == null || v.isEmpty) ? 'Enter amount' : null,
              ),
              const SizedBox(height: 16),
              // Category Picker
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4AF37).withOpacity(0.18),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.4)),
                  ),
                  child: const Icon(Icons.category_outlined, color: Color(0xFFD4AF37), size: 20),
                ),
                title: Text(
                  _category,
                  style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, color: isDark ? Colors.white : const Color(0xFF111827)),
                ),
                trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFFD4AF37)),
                onTap: () async {
                  final newCat = await showDialog<String>(
                    context: context,
                    builder: (_) => AlertDialog(
                      backgroundColor: isDark ? const Color(0xFF1B1411) : const Color(0xFFFFFDF9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                        side: const BorderSide(color: Color(0xFFD4AF37), width: 1.2),
                      ),
                      title: Text(
                        'Select Category',
                        style: GoogleFonts.cinzel(fontWeight: FontWeight.w700, color: const Color(0xFFD4AF37)),
                      ),
                      content: SizedBox(
                        width: double.maxFinite,
                        child: ListView(
                          shrinkWrap: true,
                          children: provider.categories.map((c) => ListTile(
                            title: Text(c.name, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
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
              // Date Picker
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4AF37).withOpacity(0.18),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.4)),
                  ),
                  child: const Icon(Icons.calendar_today_outlined, color: Color(0xFFD4AF37), size: 20),
                ),
                title: Text(
                  DateFormat.yMMMd().format(_selectedDate),
                  style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, color: isDark ? Colors.white : const Color(0xFF111827)),
                ),
                trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFFD4AF37)),
                onTap: () async {
                  final newDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (newDate != null) {
                    setState(() => _selectedDate = newDate);
                  }
                },
              ),
              const SizedBox(height: 12),
              // Note field
              TextFormField(
                controller: _noteCtrl,
                decoration: InputDecoration(
                  labelText: 'Add a note (Optional)',
                  labelStyle: GoogleFonts.plusJakartaSans(color: isDark ? Colors.white54 : Colors.black45, fontSize: 13),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: const Color(0xFFD4AF37).withOpacity(0.3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: const Color(0xFFD4AF37).withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFD4AF37), width: 1.5),
                  ),
                ),
                style: GoogleFonts.plusJakartaSans(color: isDark ? Colors.white : const Color(0xFF111827)),
              ),
              const SizedBox(height: 24),
              // Royal Art Nouveau Submit Button
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: palette.buttonGradient,
                  border: Border.all(color: palette.goldBorderColor, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: palette.goldBorderColor.withOpacity(0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () {
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        'RECORD FLOW',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cinzel(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
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
