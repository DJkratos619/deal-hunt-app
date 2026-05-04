import 'package:app_descuento_virtual/data/models/discount.dart';
import 'package:app_descuento_virtual/data/repositories/discount_repository.dart';

class GetDiscountUseCase {
  final IDiscountRepository _repository;

  GetDiscountUseCase(this._repository);

  Future<List<Discount>> call({String? categoryId, String? query}) async {
    if (query != null && query.isNotEmpty) {
      return _repository.search(query);
    }
    if (categoryId != null && categoryId != 'all') {
      return _repository.getByCategory(categoryId);
    }
    return _repository.getAll();
  }
}