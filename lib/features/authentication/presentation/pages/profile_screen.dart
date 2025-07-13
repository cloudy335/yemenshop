import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:yemenshop/core/theme/app_button.dart';
import 'package:yemenshop/core/theme/design_system.dart';

class Address {
  String name;
  String details;
  double lat;
  double lng;

  Address({
    required this.name,
    required this.details,
    required this.lat,
    required this.lng,
  });
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEditing = false;
  bool isSaving = false;

  late TextEditingController nameController;
  late TextEditingController emailController;

  String avatarUrl =
      "https://www.gravatar.com/avatar/placeholder?s=200&d=robohash";

  // Notification Preferences
  bool notifyOffers = true;
  bool notifyOrders = true;
  bool notifyAccount = true;

  List<Address> userAddresses = [
    Address(
      name: "البيت",
      details: "شارع الخمسين، حي السنينة، صنعاء، أمانة العاصمة، اليمن",
      lat: 15.3694,
      lng: 44.1910,
    ),
    Address(
      name: "العمل",
      details: "الحصبة، صنعاء، أمانة العاصمة، اليمن",
      lat: 15.3542,
      lng: 44.2071,
    ),
  ];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: "أحمد محمد");
    emailController = TextEditingController(text: "ahmad.mohamed@email.com");
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> saveProfile() async {
    setState(() => isSaving = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      isSaving = false;
      isEditing = false;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حفظ التعديلات بنجاح')),
      );
    }
  }

  void showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final oldPass = TextEditingController();
        final newPass = TextEditingController();
        final confirmPass = TextEditingController();
        return AlertDialog(
          title: const Text("تغيير كلمة المرور"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: oldPass,
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: "كلمة المرور الحالية"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: newPass,
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: "كلمة المرور الجديدة"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: confirmPass,
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: "تأكيد كلمة المرور"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            AppButton(
              label: "تغيير",
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم تغيير كلمة المرور بنجاح')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void showManageAddressesDialog() {
    final parentContext = context;
    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(parentContext).viewInsets.bottom,
              right: AppSpacing.lg,
              left: AppSpacing.lg,
              top: AppSpacing.lg,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('عناويني المحفوظة', style: AppTextStyles.h2),
                const SizedBox(height: 16),
                ...userAddresses.asMap().entries.map((entry) {
                  int i = entry.key;
                  Address address = entry.value;
                  return ListTile(
                    leading: const Icon(Icons.place, color: AppColors.primary),
                    title: Text('${address.name} - ${address.details}',
                        style: const TextStyle(fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.edit, color: AppColors.primary),
                          onPressed: () async {
                            final controller =
                                TextEditingController(text: address.name);
                            final newName = await showDialog<String>(
                              context: parentContext,
                              builder: (dialogContext) => AlertDialog(
                                title: const Text("تعديل اسم العنوان"),
                                content: TextField(
                                  controller: controller,
                                  decoration: const InputDecoration(
                                      hintText: "اسم العنوان"),
                                  textDirection: TextDirection.rtl,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(dialogContext, null),
                                    child: const Text("إلغاء"),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(
                                        dialogContext, controller.text),
                                    child: const Text("حفظ"),
                                  ),
                                ],
                              ),
                            );
                            if (newName != null && newName.trim().isNotEmpty) {
                              setSheetState(() {
                                setState(() {
                                  userAddresses[i].name = newName.trim();
                                });
                              });
                            }
                          },
                        ),
                        IconButton(
                          icon:
                              const Icon(Icons.delete, color: AppColors.error),
                          onPressed: () {
                            setSheetState(() {
                              setState(() {
                                userAddresses.removeAt(i);
                              });
                            });
                          },
                        ),
                      ],
                    ),
                    onTap: () {},
                  );
                }).toList(),
                const SizedBox(height: 8),
                AppButton(
                  label: "إضافة عنوان جديد",
                  onPressed: () async {
                    Navigator.pop(sheetContext);
                    final LatLng? selectedLatLng =
                        await Navigator.pushNamed(parentContext, '/map')
                            as LatLng?;
                    if (selectedLatLng != null) {
                      List<Placemark> placemarks =
                          await placemarkFromCoordinates(
                        selectedLatLng.latitude,
                        selectedLatLng.longitude,
                      );
                      final p = placemarks.first;
                      String? country = p.country;
                      if (country == "Saudi Arabia") country = "السعودية";
                      if (country == "Yemen") country = "اليمن";
                      String details = [
                        if (p.street != null && p.street!.isNotEmpty) p.street,
                        if (p.subLocality != null && p.subLocality!.isNotEmpty)
                          p.subLocality,
                        if (p.locality != null && p.locality!.isNotEmpty)
                          p.locality,
                        if (p.administrativeArea != null &&
                            p.administrativeArea!.isNotEmpty)
                          p.administrativeArea,
                        if (country != null && country.isNotEmpty) country,
                      ].join('، ');

                      final nameController = TextEditingController();
                      final name = await showDialog<String>(
                        context: parentContext,
                        builder: (dialogContext) => AlertDialog(
                          title: const Text(
                              "أدخل اسم العنوان (مثلاً: البيت، العمل)"),
                          content: TextField(
                            controller: nameController,
                            decoration:
                                const InputDecoration(hintText: "اسم العنوان"),
                            textDirection: TextDirection.rtl,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(dialogContext, null),
                              child: const Text("إلغاء"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(
                                  dialogContext, nameController.text),
                              child: const Text("حفظ"),
                            ),
                          ],
                        ),
                      );

                      if (name != null && name.trim().isNotEmpty) {
                        setState(() {
                          userAddresses.add(Address(
                            name: name,
                            details: details,
                            lat: selectedLatLng.latitude,
                            lng: selectedLatLng.longitude,
                          ));
                        });
                        ScaffoldMessenger.of(parentContext).showSnackBar(
                            const SnackBar(
                                content: Text('تم إضافة العنوان بنجاح')));
                      }
                    }
                  },
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.pop(sheetContext),
                  child: const Text('إغلاق'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showNotificationPrefsDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      builder: (_) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('تفضيلات الإشعارات', style: AppTextStyles.h2),
              SwitchListTile(
                value: notifyOffers,
                title: const Text('إشعارات العروض والتخفيضات'),
                onChanged: (v) => setSheetState(() {
                  setState(() => notifyOffers = v);
                }),
              ),
              SwitchListTile(
                value: notifyOrders,
                title: const Text('إشعارات حالة الطلبات'),
                onChanged: (v) => setSheetState(() {
                  setState(() => notifyOrders = v);
                }),
              ),
              SwitchListTile(
                value: notifyAccount,
                title: const Text('إشعارات الحساب والتحديثات'),
                onChanged: (v) => setSheetState(() {
                  setState(() => notifyAccount = v);
                }),
              ),
              const SizedBox(height: 8),
              AppButton(
                label: "حفظ التفضيلات",
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إغلاق'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void goToMyOrders() {
    Navigator.pushNamed(context, '/orders');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.appBarTheme.backgroundColor,
          elevation: 0,
          title: Text('الملف الشخصي',
              style: AppTextStyles.h2.copyWith(
                color: theme.colorScheme.onBackground,
              )),
          centerTitle: true,
          actions: [
            if (!isEditing)
              IconButton(
                tooltip: 'تعديل',
                icon: Icon(Icons.edit, color: theme.colorScheme.primary),
                onPressed: () {
                  setState(() => isEditing = true);
                },
              ),
            if (isEditing)
              IconButton(
                tooltip: 'إلغاء',
                icon: Icon(Icons.close, color: theme.colorScheme.primary),
                onPressed: () {
                  setState(() => isEditing = false);
                },
              ),
          ],
        ),
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // صورة الملف
                        Stack(
                          alignment: Alignment.bottomLeft,
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundImage: NetworkImage(avatarUrl),
                            ),
                            if (isEditing)
                              Positioned(
                                bottom: 0,
                                left: 5,
                                child: Material(
                                  color: theme.colorScheme.surface,
                                  shape: const CircleBorder(),
                                  child: IconButton(
                                    icon: Icon(Icons.camera_alt,
                                        color: theme.colorScheme.primary,
                                        size: 22),
                                    onPressed: () {},
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          child: isEditing
                              ? Column(
                                  key: const ValueKey('edit'),
                                  children: [
                                    _ProfileField(
                                      label: 'الاسم',
                                      controller: nameController,
                                      enabled: isEditing,
                                    ),
                                    const SizedBox(height: AppSpacing.md),
                                    _ProfileField(
                                      label: 'البريد الإلكتروني',
                                      controller: emailController,
                                      enabled: isEditing,
                                      keyboardType: TextInputType.emailAddress,
                                    ),
                                  ],
                                )
                              : Column(
                                  key: const ValueKey('view'),
                                  children: [
                                    Text(
                                      nameController.text,
                                      style: AppTextStyles.h2.copyWith(
                                        color: theme.colorScheme.onBackground,
                                      ),
                                    ),
                                    const SizedBox(height: AppSpacing.sm),
                                    Text(
                                      emailController.text,
                                      style: AppTextStyles.body1.copyWith(
                                        color: theme.colorScheme.onBackground,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Divider(
                            color: theme.colorScheme.onBackground
                                .withOpacity(0.2)),
                        ProfileOptionTile(
                          icon: Icons.lock,
                          title: 'تغيير كلمة المرور',
                          onTap: showChangePasswordDialog,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        ProfileOptionTile(
                          icon: Icons.location_on,
                          title: 'إدارة العناوين المحفوظة',
                          onTap: showManageAddressesDialog,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        ProfileOptionTile(
                          icon: Icons.notifications,
                          title: 'تفضيلات الإشعارات',
                          onTap: showNotificationPrefsDialog,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        // هنا زر "طلباتي"
                        ProfileOptionTile(
                          icon: Icons.shopping_bag,
                          title: 'طلباتي',
                          onTap: goToMyOrders,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        ProfileOptionTile(
                          icon: Icons.logout,
                          title: 'تسجيل الخروج',
                          iconColor: AppColors.error,
                          onTap: () {},
                        ),
                      ],
                    ),
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

class _ProfileField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool enabled;
  final TextInputType? keyboardType;
  const _ProfileField({
    required this.label,
    required this.controller,
    this.enabled = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      textAlign: TextAlign.right,
      style: AppTextStyles.body1.copyWith(
        color: theme.colorScheme.onSurface,
      ),
      decoration: AppInputStyles.defaultDecoration(label: label).copyWith(
        filled: true,
        fillColor: enabled
            ? theme.colorScheme.surface
            : theme.colorScheme.surface.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.normal),
          borderSide: BorderSide(
            color: theme.colorScheme.onSurface.withOpacity(0.3),
          ),
        ),
      ),
    );
  }
}

class ProfileOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Color? iconColor;
  const ProfileOptionTile({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(AppRadius.normal),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.normal),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 12),
          child: Row(
            children: [
              Icon(icon, color: iconColor ?? theme.colorScheme.primary),
              const SizedBox(width: 20),
              Expanded(
                child: Text(title,
                    style: AppTextStyles.body1.copyWith(
                      color: theme.colorScheme.onBackground,
                    )),
              ),
              Icon(Icons.arrow_back_ios,
                  size: 17, color: theme.colorScheme.onBackground)
            ],
          ),
        ),
      ),
    );
  }
}
