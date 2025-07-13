import 'package:flutter/material.dart';
import 'package:yemenshop/core/theme/design_system.dart';

class AppBarContent extends StatelessWidget {
  const AppBarContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Row(
          children: [
            // Logo remains on the left
            Image.asset(
              "assets/images/Logo.png",
              width: 50,
              height: 50,
            ),
            const SizedBox(width: AppSpacing.md),
            // Search bar takes remaining space
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: theme.colorScheme.onBackground.withOpacity(0.3),
                      width: 1),
                  borderRadius: BorderRadius.circular(AppRadius.normal),
                ),
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Icon(Icons.search,
                        color: theme.colorScheme.onBackground.withOpacity(0.7)),
                    const SizedBox(width: AppSpacing.sm),
                    Text('ابحث',
                        style: AppTextStyles.body2.copyWith(
                          color:
                              theme.colorScheme.onBackground.withOpacity(0.7),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
