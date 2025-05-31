import 'package:flutter/material.dart';
import 'package:yemenshop/core/theme/design_system.dart';

// Make sure to import your custom classes/constants:
// import 'path_to_your_constants.dart';

class PromoCarousel extends StatelessWidget {
  final PageController promoController;
  final List<PromoAd> promoAds;

  const PromoCarousel({
    Key? key,
    required this.promoController,
    required this.promoAds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: SizedBox(
        height: 180,
        child: PageView.builder(
          controller: promoController,
          itemCount: promoAds.length,
          itemBuilder: (context, index) {
            final p = promoAds[index];
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    spreadRadius: 1,
                    offset: const Offset(0, 2),
                  ),
                ],
                borderRadius: BorderRadius.circular(AppRadius.normal),
                image: DecorationImage(
                  image: AssetImage(p.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.title,
                      style: AppTextStyles.h2.copyWith(
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            offset: const Offset(1, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      p.price,
                      style: AppTextStyles.body1.copyWith(
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            offset: const Offset(1, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Example PromoAd class (replace with your actual model)
class PromoAd {
  final String imagePath;
  final String title;
  final String price;

  PromoAd({
    required this.imagePath,
    required this.title,
    required this.price,
    required String id,
    required String subtitle,
  });
}
