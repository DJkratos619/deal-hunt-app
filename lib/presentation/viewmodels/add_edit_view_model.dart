import 'package:app_descuento_virtual/data/models/discount.dart';
import 'package:app_descuento_virtual/domain/use_cases/delete_discount_use_case.dart';
import 'package:app_descuento_virtual/domain/use_cases/save_discount_use_case.dart';
import 'package:app_descuento_virtual/presentation/viewmodels/home_view_model.dart';
import 'package:flutter/foundation.dart';

class AddEditViewModel extends ChangeNotifier {
  final SaveDiscountUseCase _saveDiscountUseCase;
  final DeleteDiscountUseCase _deleteDiscountUseCase;

  AddEditViewModel({
    required SaveDiscountUseCase saveDiscountUseCase,
    required DeleteDiscountUseCase deleteDiscountUseCase,
  }) : _saveDiscountUseCase = saveDiscountUseCase,
       _deleteDiscountUseCase = deleteDiscountUseCase;

  ViewState _state = ViewState.idle;
  Discount? _editingDiscount;
  String? _errorMessage;
  bool _saveSuccess = false;

  ViewState get state => _state;
  Discount? get editingDiscount => _editingDiscount;
  String? get errorMessage => _errorMessage;
  bool get isEditing => _editingDiscount?.id != null;
  bool get isLoading => _state == ViewState.loading;
  bool get saveSucces => _saveSuccess;

  void initForEdit(Discount discount) {
    _editingDiscount = discount;
    notifyListeners();
  }

  void resetSuccess() {
    _saveSuccess = false;
  }

  Future<bool> save({
    required String title,
    required String description,
    required double percentage,
    required String categoryId,
    required String storeName,
    required String couponCode,
    required DateTime expirationDate,
  }) async {
    _setState(ViewState.loading);
    try {
      final discount = Discount(
        id: _editingDiscount?.id,
        title: title.trim(),
        description: description.trim(),
        percentage: percentage,
        categoryId: categoryId,
        storeName: storeName.trim(),
        couponCode: couponCode.trim().toUpperCase(),
        expirationDate: expirationDate,
        isFavorite: _editingDiscount?.isFavorite ?? false,
        createdAt: _editingDiscount?.createdAt ?? DateTime.now(),
      ); // Discount

      await _saveDiscountUseCase(discount);
      _saveSuccess = true;
      _setState(ViewState.success);
      return true;
    } catch (e) {
      _errorMessage = 'Error al guardar: $e';
      _setState(ViewState.error);
      return false;
    }
  }

  Future<bool> delete(int id) async {
  _setState(ViewState.loading);
  try {
    await _deleteDiscountUseCase(id);
    _setState(ViewState.success);
    return true;
  } catch (e) {
    _errorMessage = 'Error al eliminar: $e';
    _setState(ViewState.error);
    return false;
  }
}

  void _setState(ViewState state) {
    _state = state;
    notifyListeners();
  }
}
