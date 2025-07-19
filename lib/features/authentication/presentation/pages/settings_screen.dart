import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yemenshop/core/theme/design_system.dart';
import 'package:yemenshop/features/authentication/presentation/bloc/theme_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _autoLoginEnabled = true;
  bool _darkModeEnabled = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        appBar: AppBar(
          backgroundColor: theme.colorScheme.surface,
          foregroundColor: theme.colorScheme.onSurface,
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'الإعدادات',
            style: AppTextStyles.h2.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        body: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            ThemeMode currentMode = ThemeMode.dark;

            if (state is ThemeLoaded) {
              currentMode = state.themeMode;
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Preferences Section
                  _buildSectionHeader('التفضيلات', theme),
                  _buildSettingsCard([
                    _buildSwitchTile(
                      icon: Icons.notifications,
                      title: 'الإشعارات',
                      subtitle: 'استلام إشعارات التطبيق',
                      value: _notificationsEnabled,
                      onChanged: (value) {
                        setState(() {
                          _notificationsEnabled = value;
                        });
                      },
                      theme: theme,
                    ),
                    _buildSwitchTile(
                      icon: Icons.login,
                      title: 'تسجيل الدخول التلقائي',
                      subtitle: 'تسجيل الدخول عند فتح التطبيق',
                      value: _autoLoginEnabled,
                      onChanged: (value) {
                        setState(() {
                          _autoLoginEnabled = value;
                        });
                      },
                      theme: theme,
                    ),
                  ], theme),

                  const SizedBox(height: AppSpacing.lg),

                  // Appearance Section
                  _buildSectionHeader('المظهر', theme),
                  _buildSettingsCard([
                    _buildSwitchTile(
                      icon: Icons.dark_mode,
                      title: 'الوضع الداكن',
                      subtitle: 'تفعيل المظهر الداكن',
                      value: _darkModeEnabled,
                      onChanged: (value) {
                        setState(() {
                          _darkModeEnabled = value;
                        });
                        // Update theme based on toggle
                        final newThemeMode =
                            value ? ThemeMode.dark : ThemeMode.light;
                        context
                            .read<ThemeBloc>()
                            .add(ThemeChanged(themeMode: newThemeMode));
                      },
                      theme: theme,
                    ),
                  ], theme),

                  const SizedBox(height: AppSpacing.lg),

                  // Privacy & Security Section
                  _buildSectionHeader('الخصوصية والأمان', theme),
                  _buildSettingsCard([
                    _buildSettingsTile(
                      icon: Icons.security,
                      title: 'كلمة المرور',
                      subtitle: 'تغيير كلمة المرور',
                      onTap: () {
                        // Navigate to password change
                      },
                      theme: theme,
                    ),
                    _buildSettingsTile(
                      icon: Icons.privacy_tip,
                      title: 'سياسة الخصوصية',
                      subtitle: 'قراءة سياسة الخصوصية',
                      onTap: () {
                        // Navigate to privacy policy
                      },
                      theme: theme,
                    ),
                    _buildSettingsTile(
                      icon: Icons.description,
                      title: 'شروط الاستخدام',
                      subtitle: 'قراءة شروط الاستخدام',
                      onTap: () {
                        // Navigate to terms of service
                      },
                      theme: theme,
                    ),
                  ], theme),

                  const SizedBox(height: AppSpacing.lg),

                  // Support Section
                  _buildSectionHeader('الدعم', theme),
                  _buildSettingsCard([
                    _buildSettingsTile(
                      icon: Icons.help,
                      title: 'المساعدة',
                      subtitle: 'دليل الاستخدام',
                      onTap: () {
                        // Navigate to help
                      },
                      theme: theme,
                    ),
                    _buildSettingsTile(
                      icon: Icons.contact_support,
                      title: 'تواصل معنا',
                      subtitle: 'إرسال رسالة للدعم',
                      onTap: () {
                        // Navigate to contact support
                      },
                      theme: theme,
                    ),
                    _buildSettingsTile(
                      icon: Icons.bug_report,
                      title: 'الإبلاغ عن مشكلة',
                      subtitle: 'إبلاغ عن خطأ في التطبيق',
                      onTap: () {
                        // Navigate to bug report
                      },
                      theme: theme,
                    ),
                  ], theme),

                  const SizedBox(height: AppSpacing.lg),

                  // About Section
                  _buildSectionHeader('حول التطبيق', theme),
                  _buildSettingsCard([
                    _buildSettingsTile(
                      icon: Icons.info,
                      title: 'إصدار التطبيق',
                      subtitle: '1.0.0',
                      onTap: null,
                      theme: theme,
                    ),
                    _buildSettingsTile(
                      icon: Icons.star,
                      title: 'تقييم التطبيق',
                      subtitle: 'ساعدنا بتحسين التطبيق',
                      onTap: () {
                        // Navigate to app store rating
                      },
                      theme: theme,
                    ),
                    _buildSettingsTile(
                      icon: Icons.share,
                      title: 'مشاركة التطبيق',
                      subtitle: 'شارك التطبيق مع الأصدقاء',
                      onTap: () {
                        // Share app
                      },
                      theme: theme,
                    ),
                  ], theme),

                  const SizedBox(height: AppSpacing.lg),

                  // Logout Section
                  _buildSettingsCard([
                    _buildSettingsTile(
                      icon: Icons.logout,
                      title: 'تسجيل الخروج',
                      subtitle: 'الخروج من الحساب',
                      onTap: () {
                        _showLogoutDialog(context, theme);
                      },
                      theme: theme,
                      textColor: Colors.red,
                    ),
                  ], theme),

                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        title,
        style: AppTextStyles.h2.copyWith(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children, ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    if (isDark) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.normal),
        ),
        child: Column(
          children: children,
        ),
      );
    } else {
      // In light mode, just return the children without card wrapper
      return Column(
        children: children,
      );
    }
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
    required ThemeData theme,
    bool showArrow = false,
    Color? textColor,
  }) {
    return ListTile(
      leading: ShaderMask(
        shaderCallback: (bounds) =>
            AppColors.primaryGradient.createShader(bounds),
        child: Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: AppTextStyles.body1.copyWith(
          color: textColor ?? theme.colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.body2.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
        ),
      ),
      trailing: showArrow
          ? Icon(
              Icons.arrow_forward_ios,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              size: 16,
            )
          : null,
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required ThemeData theme,
  }) {
    return ListTile(
      leading: ShaderMask(
        shaderCallback: (bounds) =>
            AppColors.primaryGradient.createShader(bounds),
        child: Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: AppTextStyles.body1.copyWith(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.body2.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
        ),
      ),
      trailing: _buildGradientSwitch(value, onChanged),
    );
  }

  Widget _buildGradientSwitch(bool value, ValueChanged<bool> onChanged) {
    return SizedBox(
      width: 50,
      height: 30,
      child: GestureDetector(
        onTap: () => onChanged(!value),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.grey.withValues(alpha: 0.3),
          ),
          child: Stack(
            children: [
              // Track
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.transparent,
                  ),
                ),
              ),
              // Thumb
              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                left: value ? 20 : 2,
                top: 2,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    color: value ? null : Colors.grey,
                  ),
                  child: value
                      ? ShaderMask(
                          shaderCallback: (bounds) =>
                              AppColors.primaryGradient.createShader(bounds),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(13),
                              color: Colors.white,
                            ),
                          ),
                        )
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, ThemeData theme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'تسجيل الخروج',
          style: AppTextStyles.h2.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        content: Text(
          'هل أنت متأكد من تسجيل الخروج؟',
          style: AppTextStyles.body1.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
          TextButton(
            onPressed: () {
              // Handle logout
              Navigator.pop(context);
              // Navigate to login screen
            },
            child: Text(
              'تسجيل الخروج',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
