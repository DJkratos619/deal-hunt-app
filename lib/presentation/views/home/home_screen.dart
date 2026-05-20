import 'package:app_descuento_virtual/core/constants/app_colors.dart';
import 'package:app_descuento_virtual/core/constants/app_strings.dart';
import 'package:app_descuento_virtual/data/models/category.dart';
import 'package:app_descuento_virtual/presentation/viewmodels/home_view_model.dart';
import 'package:app_descuento_virtual/presentation/views/home/widgets/category_chip_widget.dart';
import 'package:app_descuento_virtual/presentation/views/home/widgets/dicount_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().loadDiscounts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(isDark),
            _buildSearchBar(isDark),
            _buildCategories(),
            Expanded(child: _buildDiscountsList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hola ',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white54 : Colors.grey,
                    fontWeight: FontWeight.w500,
                  ), // TextStyle
                ), // Text
                const SizedBox(height: 2),
                const Text(
                  AppStrings.homeTitle,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ), // TextStyle
                ), // Text
              ],
            ), // Column
          ), // Expanded
          Consumer<HomeViewModel>(
            builder: (_, vm, __) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: AppColors.accentGradient,
                borderRadius: BorderRadius.circular(20),
              ), // BoxDecoration
              child: Row(
                children: [
                  const Icon(
                    Icons.local_offer_rounded,
                    color: Colors.white,
                    size: 16,
                  ), // Icon
                  const SizedBox(width: 6),
                  Text(
                    '${vm.discount.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ), // TextStyle
                  ), // Text
                ],
              ), // Row
            ), // Container
          ), // Consumer
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocus,
        onChanged: (v) => context.read<HomeViewModel>().onSearchChanged(v),
        style: const TextStyle(fontSize: 15),
        decoration: InputDecoration(
          hintText: AppStrings.searchHint,
          prefixIcon: const Icon(Icons.search_rounded, size: 22),
          suffixIcon: Consumer<HomeViewModel>(
            builder: (_, vm, _) => vm.searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () {
                      _searchController.clear();
                      vm.clearSearch();
                      _searchFocus.unfocus();
                    },
                  ) // IconButton
                : const SizedBox.shrink(),
          ), // Consumer
        ), // InputDecoration
      ), // TextField
    ); // Padding
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 48,
      child: Consumer<HomeViewModel>(
        builder: (_, vm, _) => ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: Categories.all.length,
          itemBuilder: (_, index) {
            final cat = Categories.all[index];
            return CategoryChipWidget(
              category: cat,
              isSelected: vm.selectedCategoryId == cat.id,
              onTap: () => vm.selectCategory(cat.id),
            ); // CategoryChipWidget
          },
        ), // ListView.builder
      ), // Consumer
    ); // SizedBox
  }

  Widget _buildDiscountsList() {
    return Consumer<HomeViewModel>(
      builder: (_, vm, _) {
        if (vm.isLoading) {
          return const Center(child: CircularProgressIndicator()); // Center
        }

        if (vm.state == ViewState.error) {
          return _buildErrorState(vm.errorMessage);
        }

        if (vm.discount.isEmpty) {
          return _buildEmptyState();
        }
        return RefreshIndicator(
          onRefresh: vm.loadDiscounts,
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
            itemCount: vm.discount.length,
            itemBuilder: (_, index) {
              final discount = vm.discount[index];
              return DiscountCard(
                discount: discount,
                onTap: () => Navigator.pushNamed(
                  context,
                  '/detail',
                  arguments: discount,
                ).then((_) => vm.loadDiscounts()),
                onFavorite: () =>
                    vm.toggleFavorite(discount.id!, discount.isFavorite),
              ); // DiscountCard
            },
          ), // ListView.builder
        ); // RefreshIndicator
      },
    ); // Consumer
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ), // BoxDecoration
            child: const Icon(
              Icons.search_off_rounded,
              size: 40,
              color: AppColors.primary,
            ), // Icon
          ), // Container
          const SizedBox(height: 16),
          const Text(
            AppStrings.noDiscounts,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ), // Text
          const SizedBox(height: 8),
          Text(
            'Intenta con otra categoría o búsqueda',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white54
                  : Colors.grey,
            ), // TextStyle
          ), // Text
        ],
      ), // Column
    ); // Center
  }

  Widget _buildErrorState(String? message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 48,
            color: AppColors.error,
          ),
          const SizedBox(height: 12),
          Text(
            message ?? 'Ocurrió un error',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15),
          ), // Text
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<HomeViewModel>().loadDiscounts(),
            child: const Text('Reintentar'),
          ), // ElevatedButton
        ],
      ), // Column
    ); // Center
  }
}
