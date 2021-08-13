import 'package:flutter/material.dart';
import 'package:seeds/v2/components/notification_badge.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/domain-shared/ui_constants.dart';
import 'package:seeds/v2/design/app_theme.dart';

/// CARD LIST TILE
class CardListTile extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final Widget trailing;
  final VoidCallback onTap;
  final bool hasNotification;

  const CardListTile({
    Key? key,
    required this.leadingIcon,
    required this.title,
    required this.trailing,
    required this.onTap,
    this.hasNotification = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(defaultCardBorderRadius),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.darkGreen2,
          borderRadius: BorderRadius.circular(defaultCardBorderRadius),
        ),
        child: ListTile(
          leading: Icon(leadingIcon),
          title: Row(
            children: [
              Text(title, style: Theme.of(context).textTheme.buttonLowEmphasis),
              const SizedBox(width: 10),
              if (hasNotification) const NotificationBadge() else const SizedBox.shrink()
            ],
          ),
          trailing: trailing,
        ),
      ),
    );
  }
}
