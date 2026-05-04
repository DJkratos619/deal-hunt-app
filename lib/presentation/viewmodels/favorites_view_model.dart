import 'package:app_descuento_virtual/data/models/discount.dart';
import 'package:app_descuento_virtual/domain/use_cases/get_favorites_use_case.dart';
import 'package:app_descuento_virtual/domain/use_cases/toggle_favorite_use_case.dart';
import 'package:app_descuento_virtual/presentation/viewmodels/home_view_model.dart';
import 'package:flutter/foundation.dart';

class FavoritesViewModel extends ChangeNotifier {
  final GetFavoritesUseCase _getFavoritesUseCase;
  final ToggleFavoriteUseCase _toggleFavoriteUseCase;

  FavoritesViewModel({
    required GetFavoritesUseCase getFavoritesUseCase,
    required ToggleFavoriteUseCase toggleFavoriteUseCase,
  }) : _getFavoritesUseCase = getFavoritesUseCase,
       _toggleFavoriteUseCase = toggleFavoriteUseCase;

  ViewState _state = ViewState.idle;
  List<Discount> _favorites = [];
  String? _errorMessage;

  ViewState get state => _state;
  List<Discount> get favorites => _favorites;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == ViewState.loading;

  Future<void> loadFavorites() async {
    _setState(ViewState.loading);
    try {
      _favorites = await _getFavoritesUseCase();
      _setState(ViewState.success);
    } catch (e) {
      _errorMessage = 'Error al cargar favoritos: $e';
      _setState(ViewState.error);
    }
  }

  Future<void> removeFavorite(int id) async {
    try {
      await _toggleFavoriteUseCase(id, true);
      _favorites.removeWhere((d) => d.id == id);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error al quitar de favoritos';
      notifyListeners();
    }
  }

  void _setState(ViewState state) {
    _state = state;
    notifyListeners();
  }
}
