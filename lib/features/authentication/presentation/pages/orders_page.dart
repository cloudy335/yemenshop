import 'package:flutter/material.dart';
import 'package:yemenshop/core/theme/app_button.dart';
import 'package:yemenshop/core/theme/design_system.dart';

// ----------- Model classes ----------
class Product {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });
}

class Order {
  final String id;
  final String date;
  final String status;
  final double total;
  final int progress;
  final List<Product> products;

  Order({
    required this.id,
    required this.date,
    required this.status,
    required this.total,
    this.progress = 0,
    required this.products,
  });
}

// ----------- Orders Page ----------
class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<Order> get sampleOrders => [
        Order(
          id: "#123456",
          date: "2024-07-01",
          status: "قيد التنفيذ",
          total: 120.0,
          progress: 50,
          products: [
            Product(
              id: "p1",
              name: "قهوة يمنية ممتازة",
              price: 45.0,
              quantity: 2,
              imageUrl:
                  "https://dummyimage.com/100x100/ccc/fff.png&text=Coffee",
            ),
            Product(
              id: "p2",
              name: "عسل سدر طبيعي",
              price: 30.0,
              quantity: 1,
              imageUrl: "https://dummyimage.com/100x100/ddd/222.png&text=Honey",
            ),
          ],
        ),
        Order(
          id: "#123457",
          date: "2024-07-02",
          status: "تم التوصيل",
          total: 75.5,
          progress: 100,
          products: [
            Product(
              id: "p3",
              name: "بُن يمني أصلي",
              price: 25.5,
              quantity: 3,
              imageUrl:
                  "https://dummyimage.com/100x100/222/fff.png&text=Yemen+Coffee",
            ),
          ],
        ),
        Order(
          id: "#123458",
          date: "2024-07-05",
          status: "ملغي",
          total: 220.0,
          progress: 0,
          products: [
            Product(
              id: "p4",
              name: "سجاد يمني تقليدي",
              price: 150.0,
              quantity: 1,
              imageUrl: "https://dummyimage.com/100x100/333/eee.png&text=Rug",
            ),
            Product(
              id: "p5",
              name: "خنجر يمني فاخر",
              price: 70.0,
              quantity: 1,
              imageUrl:
                  "https://dummyimage.com/100x100/111/fff.png&text=Dagger",
            ),
          ],
        ),
      ];

  List<Order> displayedOrders = [];
  final TextEditingController _searchController = TextEditingController();
  Set<String> selectedFilters = {'قيد التنفيذ', 'تم التوصيل', 'ملغي'};

  @override
  void initState() {
    super.initState();
    _refreshOrders();
  }

  Future<void> _refreshOrders() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      displayedOrders = sampleOrders;
      _applyFilters();
    });
  }

  void _applyFilters() {
    setState(() {
      displayedOrders = sampleOrders
          .where((order) => selectedFilters.contains(order.status))
          .toList();
    });
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('تصفية الطلبات',
                      style: AppTextStyles.h2 ??
                          const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: AppSpacing.lg),
                  ...['قيد التنفيذ', 'تم التوصيل', 'ملغي'].map((status) {
                    return CheckboxListTile(
                      title: Text(status),
                      value: selectedFilters.contains(status),
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            selectedFilters.add(status);
                          } else {
                            selectedFilters.remove(status);
                          }
                        });
                      },
                    );
                  }),
                  const SizedBox(height: AppSpacing.md),
                  AppButton(
                    label: "تطبيق التصفية",
                    onPressed: () {
                      _applyFilters();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Color statusColor(String status) {
    switch (status) {
      case "تم التوصيل":
        return AppColors.success;
      case "ملغي":
        return AppColors.error;
      default:
        return AppColors.primary;
    }
  }

  void _navigateToOrderDetails(Order order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailsPage(order: order),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.surface,
        appBar: AppBar(
          title: Text("طلباتي",
              style: AppTextStyles.h2 ??
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          backgroundColor: AppColors.surface,
          elevation: 0.5,
          centerTitle: true,
          iconTheme: const IconThemeData(color: AppColors.primary),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: _showFilterModal,
              tooltip: 'تصفية الطلبات',
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'ابحث برقم الطلب...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.normal),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    displayedOrders = sampleOrders
                        .where((order) => order.id
                            .toLowerCase()
                            .contains(value.toLowerCase()))
                        .toList();
                  });
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refreshOrders,
                  child: displayedOrders.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.shopping_bag_outlined,
                                size: 80,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Text(
                                "لا توجد طلبات متاحة",
                                style: (AppTextStyles.h2 ??
                                        const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold))
                                    .copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                "يمكنك تجربة تغيير عوامل التصفية",
                                style: AppTextStyles.body2 ??
                                    const TextStyle(fontSize: 15),
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              SizedBox(
                                width: 180,
                                child: AppButton(
                                  label: "تحديث الطلبات",
                                  onPressed: _refreshOrders,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          itemCount: displayedOrders.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: AppSpacing.lg),
                          itemBuilder: (context, index) {
                            final order = displayedOrders[index];
                            return Container(
                              decoration: AppCardStyles.card,
                              padding: const EdgeInsets.all(AppSpacing.md),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    children: [
                                      Text(order.id,
                                          style: AppTextStyles.h3 ??
                                              const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold)),
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: statusColor(order.status)
                                              .withOpacity(0.13),
                                          borderRadius: BorderRadius.circular(
                                              AppRadius.normal),
                                        ),
                                        child: Text(
                                          order.status,
                                          style: (AppTextStyles.caption ??
                                                  const TextStyle(fontSize: 12))
                                              .copyWith(
                                            color: statusColor(order.status),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  if (order.status == "قيد التنفيذ")
                                    Column(
                                      children: [
                                        LinearProgressIndicator(
                                          value: order.progress / 100,
                                          backgroundColor: AppColors.background,
                                          color: AppColors.primary,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "اكتمال الطلب: ${order.progress}%",
                                          style: AppTextStyles.caption ??
                                              const TextStyle(fontSize: 12),
                                        ),
                                        const SizedBox(height: 8),
                                      ],
                                    ),
                                  Row(
                                    children: [
                                      Icon(Icons.calendar_today_outlined,
                                          size: 16,
                                          color: AppColors.textSecondary),
                                      const SizedBox(width: 5),
                                      Text(order.date,
                                          style: AppTextStyles.body2 ??
                                              const TextStyle(fontSize: 15)),
                                      const Spacer(),
                                      Icon(Icons.attach_money,
                                          size: 18,
                                          color: AppColors.textSecondary),
                                      const SizedBox(width: 3),
                                      Text(
                                        "${order.total} ر.س",
                                        style: (AppTextStyles.body1 ??
                                                const TextStyle(fontSize: 16))
                                            .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  if (order.products.isNotEmpty)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "المنتجات:",
                                          style: (AppTextStyles.body1 ??
                                                  const TextStyle(fontSize: 16))
                                              .copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        ...order.products
                                            .take(2)
                                            .map((product) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 6),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 40,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          product.imageUrl),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        product.name,
                                                        style: AppTextStyles
                                                                .body2 ??
                                                            const TextStyle(
                                                                fontSize: 15),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      Text(
                                                        "${product.quantity} × ${product.price} ر.س",
                                                        style: (AppTextStyles
                                                                    .caption ??
                                                                const TextStyle(
                                                                    fontSize:
                                                                        12))
                                                            .copyWith(
                                                          color: AppColors
                                                              .textSecondary,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                        if (order.products.length > 2)
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4),
                                            child: Text(
                                              "+ ${order.products.length - 2} منتجات أخرى",
                                              style: (AppTextStyles.caption ??
                                                      const TextStyle(
                                                          fontSize: 12))
                                                  .copyWith(
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          ),
                                        const SizedBox(height: 12),
                                      ],
                                    ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: SizedBox(
                                      width: 130,
                                      child: AppButton(
                                        label: "تفاصيل الطلب",
                                        onPressed: () {
                                          _navigateToOrderDetails(order);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ----------- Order Details Page ----------
class OrderDetailsPage extends StatelessWidget {
  final Order order;

  const OrderDetailsPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.surface,
        appBar: AppBar(
          title: Text("تفاصيل الطلب ${order.id}",
              style: AppTextStyles.h2 ??
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          backgroundColor: AppColors.surface,
          elevation: 0.5,
          centerTitle: true,
          iconTheme: const IconThemeData(color: AppColors.primary),
        ),
        body: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // معلومات الطلب الأساسية
              Container(
                decoration: AppCardStyles.card,
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text("رقم الطلب:",
                            style: AppTextStyles.body1 ??
                                const TextStyle(fontSize: 16)),
                        const SizedBox(width: 8),
                        Text(order.id,
                            style: (AppTextStyles.body1 ??
                                    const TextStyle(fontSize: 16))
                                .copyWith(
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text("تاريخ الطلب:",
                            style: AppTextStyles.body1 ??
                                const TextStyle(fontSize: 16)),
                        const SizedBox(width: 8),
                        Text(order.date,
                            style: (AppTextStyles.body1 ??
                                    const TextStyle(fontSize: 16))
                                .copyWith(
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text("حالة الطلب:",
                            style: AppTextStyles.body1 ??
                                const TextStyle(fontSize: 16)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color:
                                _getStatusColor(order.status).withOpacity(0.13),
                            borderRadius:
                                BorderRadius.circular(AppRadius.normal),
                          ),
                          child: Text(
                            order.status,
                            style: (AppTextStyles.caption ??
                                    const TextStyle(fontSize: 12))
                                .copyWith(
                              color: _getStatusColor(order.status),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text("المبلغ الإجمالي:",
                            style: AppTextStyles.body1 ??
                                const TextStyle(fontSize: 16)),
                        const SizedBox(width: 8),
                        Text(
                          "${order.total} ر.س",
                          style: (AppTextStyles.body1 ??
                                  const TextStyle(fontSize: 16))
                              .copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    if (order.status == "قيد التنفيذ")
                      Column(
                        children: [
                          const SizedBox(height: 16),
                          LinearProgressIndicator(
                            value: order.progress / 100,
                            backgroundColor: AppColors.background,
                            color: AppColors.primary,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "اكتمال الطلب: ${order.progress}%",
                            style: AppTextStyles.body1 ??
                                const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text("المنتجات",
                  style: AppTextStyles.h3 ??
                      const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: ListView.separated(
                  itemCount: order.products.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) {
                    final product = order.products[index];
                    return Container(
                      decoration: AppCardStyles.card,
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Row(
                        children: [
                          // صورة المنتج
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: NetworkImage(product.imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: (AppTextStyles.body1 ??
                                          const TextStyle(fontSize: 16))
                                      .copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      "الكمية: ${product.quantity}",
                                      style: AppTextStyles.body2 ??
                                          const TextStyle(fontSize: 15),
                                    ),
                                    const Spacer(),
                                    Text(
                                      "${product.price} ر.س",
                                      style: (AppTextStyles.body1 ??
                                              const TextStyle(fontSize: 16))
                                          .copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "المجموع: ${(product.price * product.quantity).toStringAsFixed(1)} ر.س",
                                  style: (AppTextStyles.body1 ??
                                          const TextStyle(fontSize: 16))
                                      .copyWith(
                                    color: AppColors.primary,
                                  ),
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
              // ملخص الطلب
              Container(
                decoration: AppCardStyles.card,
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  children: [
                    _buildSummaryRow("الإجمالي", "${order.total} ر.س"),
                    _buildSummaryRow("التوصيل", "مجانًا", isHighlighted: true),
                    const Divider(height: 24),
                    _buildSummaryRow(
                      "المجموع النهائي",
                      "${order.total} ر.س",
                      isTotal: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppButton(
                label: "العودة إلى الطلبات",
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value,
      {bool isHighlighted = false, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: isTotal
                ? AppTextStyles.h3 ??
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                : (AppTextStyles.body1 ?? const TextStyle(fontSize: 16))
                    .copyWith(
                    color: isHighlighted
                        ? AppColors.success
                        : AppColors.textSecondary,
                  ),
          ),
          const Spacer(),
          Text(
            value,
            style: isTotal
                ? (AppTextStyles.h3 ??
                        const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold))
                    .copyWith(color: AppColors.primary)
                : (AppTextStyles.body1 ?? const TextStyle(fontSize: 16))
                    .copyWith(
                    fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                  ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "تم التوصيل":
        return AppColors.success;
      case "ملغي":
        return AppColors.error;
      default:
        return AppColors.primary;
    }
  }
}
