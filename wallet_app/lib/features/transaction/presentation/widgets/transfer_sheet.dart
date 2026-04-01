library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:wallet_app/app/theme.dart';

class TransferSheet extends StatefulWidget {
  final String fromWalletId;
  final void Function(String toWalletId, double amount) onSubmit;

  const TransferSheet({
    super.key,
    required this.fromWalletId,
    required this.onSubmit,
  });

  @override
  State<TransferSheet> createState() => _TransferSheetState();
}

class _TransferSheetState extends State<TransferSheet> {
  final _formKey = GlobalKey<FormState>();
  final _toWalletController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _toWalletController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final toWalletId = _toWalletController.text.trim();
      final amount = double.parse(_amountController.text.trim());
      widget.onSubmit(toWalletId, amount);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Handle ──────────────────────────────────────────
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.textMuted.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ── Header ──────────────────────────────────────────
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: AppTheme.transferGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.swap_horiz_rounded,
                      color: Colors.white, size: 22),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transfer Funds',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      'Send to another CBE wallet',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),

            // ── From wallet info ────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.cbePurpleLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.arrow_upward_rounded,
                      color: AppTheme.cbePurple, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'From: ${widget.fromWalletId.substring(0, 8)}...',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.cbePurple,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Target Wallet Field ─────────────────────────────
            TextFormField(
              controller: _toWalletController,
              decoration: const InputDecoration(
                labelText: 'Recipient Wallet ID',
                hintText: 'Paste the target wallet ID',
                prefixIcon: Icon(Icons.account_balance_wallet_outlined),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Recipient wallet ID is required';
                }
                if (value.trim() == widget.fromWalletId) {
                  return 'Cannot transfer to the same wallet';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // ── Amount Field ────────────────────────────────────
            TextFormField(
              controller: _amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
              decoration: const InputDecoration(
                labelText: 'Amount (ETB)',
                hintText: '0.00',
                prefixIcon: Icon(Icons.attach_money_rounded),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Amount is required';
                }
                final amount = double.tryParse(value.trim());
                if (amount == null || amount <= 0) {
                  return 'Amount must be greater than zero';
                }
                if (amount > 1000000) {
                  return 'Amount cannot exceed ETB 1,000,000.00';
                }
                return null;
              },
            ),
            const SizedBox(height: 28),

            // ── Submit ──────────────────────────────────────────
            ElevatedButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.send_rounded),
              label: const Text('Send Transfer'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
