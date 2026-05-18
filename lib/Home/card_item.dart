import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plus90_application/Provider/fav_provider.dart';
import 'package:plus90_application/screens/deatils_scean.dart';
import 'package:plus90_application/utils/app-assets.dart';
import 'package:plus90_application/utils/app_color.dart';
import 'package:plus90_application/utils/app_style.dart';

class CardItem extends StatelessWidget {
  final Map<String, dynamic> dealData;
  final String id;
  final bool forceFav;

  const CardItem({
    super.key,
    required this.dealData,
    required this.id,
    this.forceFav = false,
  });

  @override
  Widget build(BuildContext context) {
    final favProvider = Provider.of<FavoritesProvider>(context);

    final isFav = forceFav || favProvider.isFavorite(id);

    final initialPrice =
        double.tryParse(dealData['initialPrice']?.toString() ?? '0') ?? 0;

    final discountedPrice =
        double.tryParse(dealData['discountedPrice']?.toString() ?? '0') ?? 0;

    final percent = initialPrice == 0
        ? 0
        : ((initialPrice - discountedPrice) / initialPrice * 100).round();

    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.grayColor3,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: () {
                  final images = dealData['images'];
                  final imageUrl = (images is List && images.isNotEmpty)
                      ? images.first.toString()
                      : null;

                  return imageUrl != null
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Image.asset(AppAssets.donut, fit: BoxFit.cover),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF8B1E3F),
                              ),
                            );
                          },
                        )
                      : Image.asset(AppAssets.donut, fit: BoxFit.cover);
                }(),
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ✅ بعد
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          dealData['title'] ?? 'Item',
                          style: AppStyle.bold18orange,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Stock: ${dealData['stock'] ?? '0'}',
                          style: AppStyle.semibold14orange,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  Text(
                    dealData['location'] ?? '',
                    style: AppStyle.medium14ramdi,
                  ),

                  Row(
                    children: [
                      Text(
                        '\$${discountedPrice.toStringAsFixed(2)}',
                        style: AppStyle.bold20orange,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '-$percent%',
                        style: AppStyle.bold18orange.copyWith(
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),

                  Text(
                    '\$${initialPrice.toStringAsFixed(2)}',
                    style: AppStyle.medium14ramdi.copyWith(
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      final dataWithId = {...dealData, 'id': id};

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              DetailsScreen(dealData: dataWithId, id: id),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Text('View Details', style: AppStyle.medium14orange),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: AppColor.orange,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
