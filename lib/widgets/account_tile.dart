import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flauth/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../models/account.dart';
import '../providers/account_provider.dart';
import '../services/icon_service.dart';

class AccountTile extends StatefulWidget {
  final Account account;

  const AccountTile({super.key, required this.account});

  @override
  State<AccountTile> createState() => _AccountTileState();
}

class _AccountTileState extends State<AccountTile> {
  bool _isCodeVisible = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final remainingSeconds = context.select<AccountProvider, int>(
      (p) => p.remainingSeconds,
    );
    final provider = Provider.of<AccountProvider>(context, listen: false);
    final code = provider.getCurrentCode(widget.account.secret);

    final formattedCode = code.length == 6
        ? '${code.substring(0, 3)} ${code.substring(3)}'
        : code;

    final issuer = widget.account.issuer.isNotEmpty
        ? widget.account.issuer
        : widget.account.name;
    final iconData = IconService.getIconForIssuer(issuer);
    final avatarColor = IconService.getColorForIssuer(issuer);

    return Dismissible(
      key: Key(widget.account.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(l10n.deleteAccount),
              content: Text(l10n.deleteAccountConfirm),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(l10n.cancel),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(l10n.delete),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        provider.deleteAccount(widget.account.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.accountDeleted(widget.account.name))),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 2,
        child: InkWell(
          onTap: () {
            setState(() {
              _isCodeVisible = !_isCodeVisible;
            });

            if (_isCodeVisible) {
              Clipboard.setData(ClipboardData(text: code));
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.codeRevealedAndCopied),
                  duration: const Duration(seconds: 1),
                ),
              );
            }
          },
          onLongPress: _isCodeVisible
              ? () {
                  Clipboard.setData(ClipboardData(text: code));
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.codeCopied),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                }
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 20.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: avatarColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: iconData != null
                        ? Icon(iconData, color: avatarColor, size: 24)
                        : Text(
                            IconService.getInitial(issuer),
                            style: TextStyle(
                              color: avatarColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              widget.account.issuer.isNotEmpty
                                  ? (_isCodeVisible
                                        ? widget.account.issuer
                                        : '${widget.account.issuer}'
                                              ' (${widget.account.name})')
                                  : widget.account.name,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: _isCodeVisible
                                        ? Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant
                                        : null,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(
                            _isCodeVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            size: 20,
                            color: Colors.grey.withValues(alpha: 0.5),
                          ),
                        ],
                      ),
                      if (_isCodeVisible) ...[
                        if (widget.account.issuer.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              widget.account.name,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              formattedCode,
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                            ),
                            Text(
                              '${remainingSeconds}s',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: remainingSeconds < 6
                                        ? Colors.red
                                        : Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
