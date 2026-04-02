
library;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import 'package:wallet_app/app/theme.dart';
import 'package:wallet_app/features/transaction/domain/entities/transaction.dart';
import 'package:wallet_app/features/transaction/domain/entities/transaction_type.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final int index;

  const TransactionTile({super.key, required this.transaction, this.index = 0});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      symbol: 'ETB ',
      decimalDigits: 2,
    );
    final dateFormat = DateFormat('MMM d, h:mm a');
    final colors = context.cbeColors;

    final (icon, color, prefix) = _getVisuals(colors);
    final bgColor = _getBgColor(colors);

    return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colors.divider),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _getTitle(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '$prefix${currencyFormat.format(transaction.amount)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: color,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      transaction.description ?? '',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors.textMuted,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    dateFormat.format(transaction.createdAtUtc.toLocal()),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colors.textMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 300.ms, delay: (index * 50).ms)
        .slideX(
          begin: 0.05,
          end: 0,
          duration: 300.ms,
          delay: (index * 50).ms,
          curve: Curves.easeOutCubic,
        );
  }

  String _getTitle() {
    return switch (transaction.type) {
      TransactionType.deposit => 'Deposit',
      TransactionType.withdrawal => 'Withdrawal',
      TransactionType.transferOut => 'Sent',
      TransactionType.transferIn => 'Received',
    };
  }

  (IconData, Color, String) _getVisuals(CbeColors colors) {
    return switch (transaction.type) {
      TransactionType.deposit => (
        Icons.south_west_rounded,
        colors.successGreen,
        '+',
      ),
      TransactionType.withdrawal => (
        Icons.north_east_rounded,
        colors.errorRed,
        '-',
      ),
      TransactionType.transferOut => (
        Icons.arrow_upward_rounded,
        colors.errorRed,
        '-',
      ),
      TransactionType.transferIn => (
        Icons.arrow_downward_rounded,
        colors.successGreen,
        '+',
      ),
    };
  }

  Color _getBgColor(CbeColors colors) {
    return switch (transaction.type) {
      TransactionType.deposit => colors.successGreenLight,
      TransactionType.withdrawal => colors.errorRedLight,
      TransactionType.transferOut => colors.errorRedLight,
      TransactionType.transferIn => colors.successGreenLight,
    };
  }
}
