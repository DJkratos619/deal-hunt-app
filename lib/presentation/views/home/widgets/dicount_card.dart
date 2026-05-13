import 'package:app_descuento_virtual/core/utils/app_formatter.dart';
import 'package:app_descuento_virtual/data/models/category.dart';
import 'package:app_descuento_virtual/data/models/discount.dart';
import 'package:flutter/material.dart';

class DiscountCard extends StatelessWidget {
  final Discount discount;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  const DiscountCard({
    super.key,
    required this.discount,
    required this.onTap,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final category = Categories.findById(discount.categoryId);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF252535) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ), // BoxShadow
          ], // BoxShadow
        ), // BoxDecoration
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(category),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          discount.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ), // TextStyle
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ), // Text
                      ), // Expanded/ Expanded
                      IconButton(
                        onPressed: onFavorite,
                        icon: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (child, animation) =>
                              ScaleTransition(scale: animation, child: child),
                          child: Icon(
                            discount.isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_outline_rounded,
                            key: ValueKey(discount.isFavorite),
                            color: discount.isFavorite
                                ? Colors.red
                                : (isDark ? Colors.white54 : Colors.grey),
                            size: 22,
                          ), // Icon
                        ), // AnimatedSwitcher
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ), // IconButton
                    ],
                  ), // Row
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.store_rounded,
                        size: 14,
                        color: isDark ? Colors.white54 : Colors.grey,
                      ), // Icon
                      const SizedBox(width: 4),
                      Text(
                        discount.storeName,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.white54 : Colors.grey,
                          fontWeight: FontWeight.w500,
                        ), //
                      ), // Text
                    ],
                  ), // Row
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      if (discount.couponCode.isNotEmpty) ...[
                        _buildCouponBadge(isDark),
                        const SizedBox(width: 8),
                      ],
                      const Spacer(),
                      _buildExpiryBadge(isDark),
                    ],
                  ), // Row
                ],
              ),
            ),
          ],
        ),
      ), // Container
    ); // GestureDetector
  }

  Widget _buildHeader(Category category) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [category.color, category.color.withOpacity(0.7)],
        ), // LinearGradient
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ), // BoxDecoration
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.12),
              ), // BoxDecoration
            ), // Container
          ), // Positioned
          Positioned(
            right: -20,
            top: -30,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ), // BoxDecoration
            ), // Container
          ),
          Positioned(
            left: 16,
            top: 0,
            bottom: 0,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Text(
                    '${discount.percentage.toInt()}%',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -1,
                    ), // TextStyle
                  ), // Text
                  const SizedBox(width: 4),
                  const Text(
                    'OFF',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ), // TextStyle
                  ), // Text
                ],
              ), // Row
            ), // Align
          ), // Positioned
          Positioned(
            right: 16,
            top: 0,
            bottom: 0,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.25),
                ), // BoxDecoration
                child: Icon(
                  Icons.local_offer_rounded,
                  color: Colors.white,
                  size: 20,
                ), // Icon
              ), // Container
            ), // Align
          ), // Positioned // Positioned
        ],
        // Container
      ), // Stack
    ); // Container Container
  }

  Widget _buildCouponBadge(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF6C63FF).withOpacity(0.2)
            : const Color(0xFFEEEDFF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF6C63FF).withOpacity(0.3),
          width: 1,
        ), // Border.all
      ), // BoxDecoration
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.confirmation_number_outlined,
            size: 12,
            color: Color(0xFF6C63FF),
          ), // Icon
          const SizedBox(width: 4),
          Text(
            discount.couponCode,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFF6C63FF),
              letterSpacing: 0.5,
            ), // TextStyle
          ), // Text
        ],
      ), // Row
    ); // ContainerContainer
  }

  Widget _buildExpiryBadge(bool isDark) {
    final isExpired = discount.isExpired;
    final isUrgent = !isExpired && discount.daysUntilExpiry <= 3;

    Color badgeColor;
    Color textColor;

    if (isExpired) {
      badgeColor = isDark
          ? const Color(0xFF9CA3AF).withOpacity(0.2)
          : const Color(0xFFF3F4F6);
      textColor = const Color(0xFF9CA3AF);
    } else if (isUrgent) {
      badgeColor = const Color(0xFFF6B35).withOpacity(0.15);
      textColor = const Color(0xFFF6B35);
    } else {
      badgeColor = const Color(0xFF10B981);
      textColor = const Color(0xFF10B981);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(8),
      ), // BoxDecoration
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isExpired ? Icons.schedule_rounded : Icons.timer_rounded,
            size: 12,
            color: textColor,
          ), // Icon
          const SizedBox(width: 4),
          Text(
            DateFormatter.expiryLabel(discount.expirationDate),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: textColor,
            ), // TextStyle
          ), // Text
        ],
      ), // Row
    ); // Containerontainer
  }
}
