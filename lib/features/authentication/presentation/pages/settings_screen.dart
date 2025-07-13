import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yemenshop/core/theme/design_system.dart';
import 'package:yemenshop/features/authentication/presentation/bloc/theme_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        appBar: AppBar(
          backgroundColor: theme.colorScheme.surface,
          foregroundColor: theme.colorScheme.onBackground,
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'الإعدادات',
            style: AppTextStyles.h2.copyWith(
              color: theme.colorScheme.onBackground,
            ),
          ),
        ),
        body: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            ThemeMode currentMode = ThemeMode.dark; // Default to dark

            if (state is ThemeLoaded) {
              currentMode = state.themeMode;
            }

            return Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'مظهر التطبيق',
                    style: AppTextStyles.h2.copyWith(
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Card(
                    child: Column(
                      children: [
                        RadioListTile<ThemeMode>(
                          title: Text(
                            'النظام (افتراضي)',
                            style: AppTextStyles.body1.copyWith(
                              color: theme.colorScheme.onBackground,
                            ),
                          ),
                          value: ThemeMode.system,
                          groupValue: currentMode,
                          onChanged: (val) {
                            if (val != null) {
                              context
                                  .read<ThemeBloc>()
                                  .add(ThemeChanged(themeMode: val));
                            }
                          },
                          activeColor: AppColors.primary,
                        ),
                        RadioListTile<ThemeMode>(
                          title: Text(
                            'فاتح',
                            style: AppTextStyles.body1.copyWith(
                              color: theme.colorScheme.onBackground,
                            ),
                          ),
                          value: ThemeMode.light,
                          groupValue: currentMode,
                          onChanged: (val) {
                            if (val != null) {
                              context
                                  .read<ThemeBloc>()
                                  .add(ThemeChanged(themeMode: val));
                            }
                          },
                          activeColor: AppColors.primary,
                        ),
                        RadioListTile<ThemeMode>(
                          title: Text(
                            'داكن',
                            style: AppTextStyles.body1.copyWith(
                              color: theme.colorScheme.onBackground,
                            ),
                          ),
                          value: ThemeMode.dark,
                          groupValue: currentMode,
                          onChanged: (val) {
                            if (val != null) {
                              context
                                  .read<ThemeBloc>()
                                  .add(ThemeChanged(themeMode: val));
                            }
                          },
                          activeColor: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
