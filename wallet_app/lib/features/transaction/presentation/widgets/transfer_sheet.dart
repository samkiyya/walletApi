/// {@template transfer_sheet}
/// Bottom sheet for initiating a wallet-to-wallet transfer.
///
/// Requires the target wallet ID and amount input. Features:
/// - Searchable wallet picker: search by owner name or wallet ID
/// - Amount input with validation matching backend rules
/// - Self-transfer prevention
/// - CBE branded
/// {@endtemplate}
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:wallet_app/app/theme.dart';
import 'package:wallet_app/di/injection_container.dart';
import 'package:wallet_app/features/wallet/domain/entities/wallet.dart';
import 'package:wallet_app/features/wallet/domain/usecases/get_wallets.dart';

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
  final _searchController = TextEditingController();

  List<Wallet> _allWallets = [];
  List<Wallet> _filteredWallets = [];
  bool _isLoadingWallets = true;
  bool _showWalletPicker = false;
  Wallet? _selectedWallet;

  @override
  void initState() {
    super.initState();
    _loadWallets();
  }

  Future<void> _loadWallets() async {
    try {
      final useCase = sl<GetWalletsUseCase>();
      final (failure, pagedResult) = await useCase(page: 1, pageSize: 100);
      if (mounted) {
        if (failure != null || pagedResult == null) {
          setState(() => _isLoadingWallets = false);
          return;
        }
        setState(() {
          // Exclude the source wallet from the picker
          _allWallets = pagedResult.items
              .where((w) => w.id != widget.fromWalletId)
              .toList();
          _filteredWallets = _allWallets;
          _isLoadingWallets = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoadingWallets = false);
    }
  }

  void _filterWallets(String query) {
    final q = query.toLowerCase().trim();
    setState(() {
      if (q.isEmpty) {
        _filteredWallets = _allWallets;
      } else {
        _filteredWallets = _allWallets.where((w) {
          final nameMatch =
              w.ownerName?.toLowerCase().contains(q) ?? false;
          final idMatch = w.id.toLowerCase().contains(q);
          return nameMatch || idMatch;
        }).toList();
      }
    });
  }

  void _selectWallet(Wallet wallet) {
    setState(() {
      _selectedWallet = wallet;
      _toWalletController.text = wallet.id;
      _showWalletPicker = false;
      _searchController.clear();
      _filteredWallets = _allWallets;
    });
  }

  @override
  void dispose() {
    _toWalletController.dispose();
    _amountController.dispose();
    _searchController.dispose();
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
    final colors = context.cbeColors;
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
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
                    color: colors.handle,
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
                      gradient: kTransferGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.swap_horiz_rounded,
                        color: colors.onGradient, size: 22),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: colors.cbePurpleLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.arrow_upward_rounded,
                        color: colors.cbePurple, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'From: ${widget.fromWalletId.substring(0, 8)}...',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colors.cbePurple,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Recipient Wallet Picker ─────────────────────────
              // Shows selected wallet or the search/pick interface
              if (_selectedWallet != null) ...[
                _buildSelectedWalletBadge(colors),
                const SizedBox(height: 12),
              ],

              // Toggle between text input and wallet picker
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Recipient',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () =>
                        setState(() => _showWalletPicker = !_showWalletPicker),
                    icon: Icon(
                      _showWalletPicker
                          ? Icons.keyboard_rounded
                          : Icons.people_alt_rounded,
                      size: 16,
                    ),
                    label: Text(
                      _showWalletPicker
                          ? 'Enter ID manually'
                          : 'Search wallets',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              if (_showWalletPicker)
                _buildWalletSearchPicker(colors, scheme)
              else ...[
                // ── Target Wallet Field ─────────────────────────────
                TextFormField(
                  controller: _toWalletController,
                  decoration: InputDecoration(
                    labelText: 'Recipient Wallet ID',
                    hintText: 'Paste the target wallet ID',
                    prefixIcon: Icon(Icons.account_balance_wallet_outlined,
                        color: colors.textMuted),
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
              ],
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
                decoration: InputDecoration(
                  labelText: 'Amount (ETB)',
                  hintText: '0.00',
                  prefixIcon: Icon(Icons.attach_money_rounded,
                      color: colors.textMuted),
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
      ),
    );
  }

  // ── Selected wallet badge ─────────────────────────────────────────
  Widget _buildSelectedWalletBadge(CbeColors colors) {
    final w = _selectedWallet!;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.successGreenLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.successGreen.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_rounded,
              color: colors.successGreen, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  w.ownerName ?? 'Anonymous',
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'ID: ${w.id.substring(0, 12)}...',
                  style: TextStyle(
                    color: colors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => setState(() {
              _selectedWallet = null;
              _toWalletController.clear();
            }),
            child: Icon(Icons.close_rounded,
                color: colors.textMuted, size: 18),
          ),
        ],
      ),
    );
  }

  // ── Wallet search & picker ────────────────────────────────────────
  Widget _buildWalletSearchPicker(CbeColors colors, ColorScheme scheme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Search field
        TextField(
          controller: _searchController,
          onChanged: _filterWallets,
          decoration: InputDecoration(
            hintText: 'Search by name or wallet ID...',
            prefixIcon:
                Icon(Icons.search_rounded, color: colors.textMuted),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear_rounded,
                        color: colors.textMuted),
                    onPressed: () {
                      _searchController.clear();
                      _filterWallets('');
                    },
                  )
                : null,
            filled: true,
            fillColor: colors.inputFill,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colors.divider),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colors.divider),
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Wallet list
        Container(
          constraints: const BoxConstraints(maxHeight: 180),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors.divider),
          ),
          child: _isLoadingWallets
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: CircularProgressIndicator(
                        color: scheme.primary, strokeWidth: 2),
                  ),
                )
              : _filteredWallets.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          _searchController.text.isEmpty
                              ? 'No other wallets found'
                              : 'No wallets match your search',
                          style: TextStyle(
                            color: colors.textMuted,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      itemCount: _filteredWallets.length,
                      separatorBuilder: (context, index) =>
                          Divider(height: 1, color: colors.divider),
                      itemBuilder: (context, index) {
                        final w = _filteredWallets[index];
                        return ListTile(
                          dense: true,
                          leading: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: colors.cbePurpleLight,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.account_balance_wallet_rounded,
                              color: colors.cbePurple,
                              size: 16,
                            ),
                          ),
                          title: Text(
                            w.ownerName ?? 'Anonymous',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: colors.textPrimary,
                            ),
                          ),
                          subtitle: Text(
                            '${w.id.substring(0, 12)}...',
                            style: TextStyle(
                              fontSize: 11,
                              color: colors.textMuted,
                            ),
                          ),
                          onTap: () => _selectWallet(w),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}
