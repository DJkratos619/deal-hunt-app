import 'package:app_descuento_virtual/data/models/discount.dart';
import 'package:app_descuento_virtual/domain/use_cases/delete_discount_use_case.dart';
import 'package:app_descuento_virtual/domain/use_cases/get_discount_use_case.dart';
import 'package:app_descuento_virtual/domain/use_cases/toggle_favorite_use_case.dart';
import 'package:flutter/foundation.dart';

enum ViewState { idle, loading, success, error }

class HomeViewModel extends ChangeNotifier {
  final GetDiscountUseCase _getDiscountUseCase;
  final ToggleFavoriteUseCase _toggleFavoriteUseCase;
  final DeleteDiscountUseCase _deleteDiscountUseCase;

  HomeViewModel({
    required GetDiscountUseCase getDiscountUseCase,
    required ToggleFavoriteUseCase toggleFavoriteUseCase,
    required DeleteDiscountUseCase deleteDiscountUseCase,
  }) : _getDiscountUseCase = getDiscountUseCase,
       _toggleFavoriteUseCase = toggleFavoriteUseCase,
       _deleteDiscountUseCase = deleteDiscountUseCase;

  ViewState _state = ViewState.idle;
  List<Discount> _discounts = [];
  String _selectedCategoryId = "all";
  String _searchQuery = '';
  String? _errorMessage;

  ViewState get state => _state;
  List<Discount> get discount => _discounts;
  String get selectedCategoryId => _selectedCategoryId;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  bool get isLoading => _state == ViewState.loading;

  Future<void> loadDiscounts() async {
    _setState(ViewState.loading);
    try {
      _discounts = await _getDiscountUseCase(
        categoryId: _selectedCategoryId,
        query: _searchQuery.isNotEmpty ? _searchQuery : null,
      );
      _setState(ViewState.success);
    } catch (e) {
      _errorMessage = 'Error al cargar descuentos: $e';
      _setState(ViewState.error);
    }
  }

  void selectCategory(String categoryId) {
    if (_selectedCategoryId == categoryId) return;
    _selectedCategoryId = categoryId;
    _searchQuery = '';
    loadDiscounts();
  }

  void onSearchChanged(String query) {
    _searchQuery = query;
    _selectedCategoryId = 'all';
    loadDiscounts();
  }

  void clearSearch() {
    _searchQuery = '';
    loadDiscounts();
  }

  void _setState(ViewState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> toggleFavorite(int id, bool currentValue) async {
    try {
      await _toggleFavoriteUseCase(id, currentValue);
      final index = _discounts.indexWhere((d) => d.id == id);
      if (index != -1) {
        _discounts[index] = _discounts[index].copyWith(
          isFavorite: !currentValue,
        );
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Error al actualizar favorito';
      notifyListeners();
    }
  }

  Future<void> deleteDiscount(int id) async {
    try {
      await _deleteDiscountUseCase(id);
      _discounts.removeWhere((d) => d.id == id);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error al eliminar descuento';
      notifyListeners();
    }
  }
}
