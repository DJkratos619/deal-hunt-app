import 'package:app_descuento_virtual/data/models/discount.dart';
import 'package:app_descuento_virtual/data/repositories/discount_repository.dart';

class GetFavoritesUseCase {
  final IDiscountRepository _repository;

  GetFavoritesUseCase(this._repository);

  Future<List<Discount>> call() async {
    return _repository.getFavorites();
  }
}