import 'package:flutter/material.dart';
import 'package:mytravaly/model/hotel_model.dart';

class PopularHotelCard extends StatelessWidget {
  final Hotel hotel;
  const PopularHotelCard({super.key, required this.hotel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final policies = hotel.propertyPoliciesAndAmmenities.data;
    final hasDiscount = hotel.markedPrice.amount > hotel.staticPrice.amount;

    final rating = hotel.googleReview.reviewPresent
        ? hotel.googleReview.overallRating.toStringAsFixed(1)
        : (hotel.propertyStar > 0 ? '${hotel.propertyStar}.0' : 'N/A');

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  hotel.propertyImage,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.broken_image, size: 48, color: Colors.grey),
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: .36),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          rating,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: .80)),
                    alignment: Alignment.center,
                    child: const Icon(Icons.favorite_border, color: Colors.redAccent),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hotel.propertyName,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: theme.primaryColor),
                    const SizedBox(width: 4),
                    Text(
                      hotel.propertyAddress.city,
                      style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  spacing: 5,
                  children: [
                    Text(
                      hotel.staticPrice.displayAmount,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (hasDiscount)
                      Text(
                        hotel.markedPrice.displayAmount,
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    Text('per night', style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade700)),
                  ],
                ),
                const SizedBox(height: 10),
                if (policies != null)
                  _AmenitiesRow(
                    freeWifi: policies.freeWifi,
                    petsAllowed: policies.petsAllowed,
                    freeCancellation: policies.freeCancellation,
                    payAtHotel: policies.payAtHotel,
                    payNow: policies.payNow,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AmenitiesRow extends StatelessWidget {
  final bool freeWifi, petsAllowed, freeCancellation, payAtHotel, payNow;
  const _AmenitiesRow({
    required this.freeWifi,
    required this.petsAllowed,
    required this.freeCancellation,
    required this.payAtHotel,
    required this.payNow,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = <_Amenity>[
      _Amenity(icon: Icons.wifi, label: 'Wi‑Fi', active: freeWifi),
      _Amenity(icon: Icons.pets, label: 'Pets', active: petsAllowed),
      _Amenity(icon: Icons.policy, label: 'Free cancel', active: freeCancellation),
      _Amenity(icon: Icons.payments, label: 'Pay@hotel', active: payAtHotel),
      _Amenity(icon: Icons.flash_on, label: 'Pay now', active: payNow),
    ].where((a) => a.active).toList();

    if (items.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 10,
      runSpacing: 8,
      children: items
          .map(
            (a) => _AmenityChip(
              icon: a.icon,
              label: a.label,
              color: theme.primaryColor.withValues(alpha: .09),
              iconColor: theme.primaryColor,
            ),
          )
          .toList(),
    );
  }
}

class _Amenity {
  final IconData icon;
  final String label;
  final bool active;
  _Amenity({required this.icon, required this.label, required this.active});
}

class _AmenityChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color iconColor;
  const _AmenityChip({required this.icon, required this.label, required this.color, required this.iconColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
