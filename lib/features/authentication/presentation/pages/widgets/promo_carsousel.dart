import 'package:flutter/material.dart';
import 'package:yemenshop/core/theme/design_system.dart';

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
    final cardHeight = 240.0;
    final cardWidth = 280.0;

    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.md,
        bottom: AppSpacing.md,
      ),
      child: SizedBox(
        height: cardHeight,
        width: cardWidth,
        child: PageView.builder(
          controller: promoController,
          itemCount: promoAds.length,
          itemBuilder: (context, index) {
            final p = promoAds[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
              elevation: 4, // Modern soft elevation
              shadowColor: Colors.black.withOpacity(0.14), // Soft, realistic
              margin: const EdgeInsets.only(bottom: 10, right: 4, left: 4),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    p.imagePath,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: cardWidth - (AppSpacing.md * 2),
                            child: Text(
                              p.title,
                              textAlign: TextAlign.right,
                              style: AppTextStyles.h2.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          SizedBox(
                            width: cardWidth - (AppSpacing.md * 2),
                            child: Text(
                              p.price,
                              textAlign: TextAlign.right,
                              style: AppTextStyles.body1.copyWith(
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.09),
                                    offset: const Offset(0, 0.5),
                                    blurRadius: 0.5,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
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
