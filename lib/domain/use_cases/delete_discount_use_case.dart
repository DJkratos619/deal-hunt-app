import 'package:app_descuento_virtual/data/repositories/discount_repository.dart';

class DeleteDiscountUseCase {
  final IDiscountRepository _repository;

  DeleteDiscountUseCase(this._repository);

  Future<int> call(int id) async {
    return _repository.delete(id);
  }
}