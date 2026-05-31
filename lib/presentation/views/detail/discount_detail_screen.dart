import 'package:app_descuento_virtual/core/constants/app_colors.dart';
import 'package:app_descuento_virtual/core/constants/app_strings.dart';
import 'package:app_descuento_virtual/core/utils/app_formatter.dart';
import 'package:app_descuento_virtual/data/models/category.dart';
import 'package:app_descuento_virtual/data/models/discount.dart';
import 'package:app_descuento_virtual/presentation/viewmodels/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class DiscountDetailScreen extends StatelessWidget {
  const DiscountDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final discount = ModalRoute.of(context)!.settings.arguments as Discount;
    final category = Categories.findById(discount.categoryId);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context, discount, category, isDark),
          SliverToBoxAdapter(
            child: _buildContent(context, discount, category, isDark),
          ), // SliverToBoxAdapter
        ],
      ), // CustomScrollView
      bottomNavigationBar: _buildBottomBar(context, discount, isDark),
    ); // Scaffold
  }

  Widget _buildSliverAppBar(
    BuildContext context,
    Discount discount,
    Category category,
    bool isDark,
  ) {
    return SliverAppBar(
      expandedHeight: 240,
      pinned: true,
      backgroundColor: isDark ? const Color(0xFF1E1E2E) : Colors.white,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ), // BoxDecoration
          child: const Icon(Icons.arrow_back_rounded, color: Colors.white),
        ), // Container
        onPressed: () => Navigator.pop(context),
      ), // IconButton
      actions: [
        Consumer<HomeViewModel>(
          builder: (_, vm, _) {
            final current = vm.discount.firstWhere(
              (d) => d.id == discount.id,
              orElse: () => discount,
            );

            return IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ), // BoxDecoration
                child: Icon(
                  current.isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_outline_rounded,
                  color: current.isFavorite ? Colors.red[300] : Colors.white,
                ), // Icon
              ), // Container
              onPressed: () =>
                  vm.toggleFavorite(discount.id!, discount.isFavorite),
            ); // IconButton
          },
        ), // Consumer
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ), // BoxDecoration
            child: const Icon(Icons.edit_rounded, color: Colors.white),
          ), // Container
          onPressed: () {
            final vm = context.read<HomeViewModel>();
            Navigator.pushNamed(
              context,
              '/add-edit',
              arguments: discount,
            ).then((_) => vm.loadDiscounts());
          },
        ), // IconButton
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [category.color, category.color.withOpacity(0.6)],
            ), // LinearGradient
          ), // BoxDecoration
          child: Stack(
            children: [
              Positioned(
                right: -40,
                top: -40,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.08),
                  ), // BoxDecoration
                ), // Container
              ), // Positioned
              Positioned(
                left: -20,
                bottom: -60,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.06),
                  ), // BoxDecoration
                ), // Container
              ),
              Positioned(
                bottom: 30,
                left: 24,
                right: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${discount.percentage.toInt()}%',
                          style: const TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -2,
                          ), // TextStyle
                        ), // Text
                        const SizedBox(width: 8),
                        const Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Text(
                            'OFF',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ), // TextStyle
                          ), // Text
                        ), // Padding
                      ],
                    ), // Row
                    Text(
                      discount.storeName,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.85),
                        fontWeight: FontWeight.w600,
                      ), // TextStyle
                    ), // Text
                  ],
                ), // Column
              ), // Positioned Positioned
            ],
          ), // Stack
        ), // Container
      ), // FlexibleSpaceBar
    ); // SliverAppBarliverAppBarSliverAppBar
  }

  Widget _buildContent(
    BuildContext context,
    Discount discount,
    Category category,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ), // BoxDecoration
                child: Text(
                  category.name,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: category.color,
                  ), // TextStyle
                ), // Text
              ), // Container

              const SizedBox(width: 8),
              if (discount.isExpired)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Vencido',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                ),
            ],
          ), // Row
          const SizedBox(height: 16),
          Text(
            discount.title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ), // TextStyle
          ), // Text
          const SizedBox(height: 16),
          if (discount.couponCode.isNotEmpty)
            _buildCouponCard(context, discount, isDark),
          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  isDark,
                  icon: Icons.store_rounded,
                  label: AppStrings.store,
                  value: discount.storeName,
                  color: AppColors.primary,
                ),
              ), // Expanded
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoCard(
                  isDark,
                  icon: Icons.schedule_rounded,
                  label: AppStrings.expiresOn,
                  value: DateFormatter.format(discount.expirationDate),
                  color: discount.isExpired
                      ? Colors.grey
                      : discount.daysUntilExpiry <= 3
                      ? AppColors.accent
                      : AppColors.success,
                ),
              ), // Expanded
            ],
          ), // Row
          const SizedBox(height: 24),
          Text(
            AppStrings.description,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ), // TextStyle
          ), // Text
          const SizedBox(height: 10),
          Text(
            discount.description,
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: isDark ? Colors.white : AppColors.textSecondary,
            ), // TextStyle
          ), // Text
          const SizedBox(height: 100),
        ],
      ), // Column
    ); // Padding
  }

  Widget _buildCouponCard(
    BuildContext context,
    Discount discount,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.primaryLight.withOpacity(0.05),
          ],
        ), // LinearGradient
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 1.5,
        ), // Border.all
      ), // BoxDecoration
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ), // BoxDecoration
            child: const Icon(
              Icons.confirmation_number_rounded,
              color: AppColors.primary,
              size: 22,
            ), // Icon
          ), // Container
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.couponCode,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white : Colors.grey,
                  ), // TextStyle
                ), // Text
                const SizedBox(height: 2),
                Text(
                  discount.couponCode,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    letterSpacing: 2,
                  ), // TextStyle
                ), // Text
              ],
            ), // ColumnColumn
          ),
          IconButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: discount.couponCode));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline_rounded,
                        color: Colors.white,
                        size: 18,
                      ), // Icon
                      SizedBox(width: 8),
                      Text(AppStrings.codeCopied),
                    ],
                  ), // Row
                  duration: Duration(seconds: 2),
                ), // SnackBar
              );
            },
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ), // BoxDecoration
              child: const Icon(
                Icons.copy_rounded,
                color: Colors.white,
                size: 18,
              ),
            ), // Container
          ), // IconButton
        ],
      ), // Row
    ); // Container
  }

  Widget _buildInfoCard(
    bool isDark, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF252525) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ), // BoxShadow
        ],
      ), // BoxDecoration
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20), // Icon
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? Colors.white54 : Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ), // Text
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ), // TextStyle
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ), // Text
        ],
      ), // Column
    ); // Container
  }

  Widget _buildBottomBar(BuildContext context, Discount discount, bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ), // BoxShadow
        ],
      ), // BoxDecoration
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                final vm = context.read<HomeViewModel>();
                Navigator.pushNamed(
                  context,
                  '/add-edit',
                  arguments: discount,
                ).then((_) => vm.loadDiscounts());
              },
              icon: const Icon(Icons.edit_rounded, size: 18),
              label: const Text('Editar'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(
                  color: AppColors.primary.withOpacity(0.5),
                  width: 1.5,
                ), // BorderSide
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ), // RoundedRectangleBorder
              ),
            ), // OutlinedButton.icon
          ), // Expanded
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: discount.couponCode.isNotEmpty
                  ? () {
                      Clipboard.setData(
                        ClipboardData(text: discount.couponCode),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(AppStrings.codeCopied),
                          duration: Duration(seconds: 2),
                        ), // SnackBar
                      );
                    }
                  : null,
              icon: const Icon(Icons.copy_rounded, size: 18),
              label: const Text(AppStrings.copyCode),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ), // RoundedRectangleBorder
              ),
            ), // ElevatedButton.icon
          ), // Expanded
        ],
      ), // Row
    ); // Container
  }
}
