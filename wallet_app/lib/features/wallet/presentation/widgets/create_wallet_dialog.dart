/// {@template create_wallet_dialog}
/// Bottom sheet dialog for creating a new wallet.
///
/// Provides a form with an optional owner name field and
/// validation. Dispatches [CreateWalletRequested] to the BLoC.
/// CBE branded with purple accent.
/// {@endtemplate}
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:wallet_app/app/theme.dart';
import 'package:wallet_app/core/presentation/utils/responsive.dart';
import 'package:wallet_app/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:wallet_app/features/wallet/presentation/bloc/wallet_event.dart';

class CreateWalletDialog extends StatefulWidget {
  const CreateWalletDialog({super.key});

  @override
  State<CreateWalletDialog> createState() => _CreateWalletDialogState();
}

class _CreateWalletDialogState extends State<CreateWalletDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim().isEmpty
          ? null
          : _nameController.text.trim();
      context.read<WalletBloc>().add(CreateWalletRequested(ownerName: name));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.cbeColors;

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: context.keyboardHeight + 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Handle bar ──────────────────────────────────────
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.handle,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ── Title ───────────────────────────────────────────
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: kCardGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.add_card_rounded,
                    color: colors.onGradient,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Create New Wallet',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Enter the wallet owner\'s name or leave blank for an anonymous wallet.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),

            // ── Name Field ──────────────────────────────────────
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: 'Owner Name',
                hintText: 'e.g. Abebe Bikila',
                prefixIcon: Icon(
                  Icons.person_outline_rounded,
                  color: colors.textMuted,
                ),
              ),
              validator: (value) {
                if (value != null &&
                    value.trim().isNotEmpty &&
                    value.trim().length < 2) {
                  return 'Name must be at least 2 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),

            // ── Submit Button ───────────────────────────────────
            ElevatedButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Create Wallet'),
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
