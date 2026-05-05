import 'package:app_descuento_virtual/data/repositories/discount_repository.dart';

class ToggleFavoriteUseCase {
  final IDiscountRepository _repository;
  ToggleFavoriteUseCase(this._repository);

  Future<void> call(int id, bool currentValue) async {
    await _repository.toggleFavorite(id, !currentValue);
  }
}