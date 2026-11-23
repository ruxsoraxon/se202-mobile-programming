import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/product_api.dart';
import '../models/product.dart';
import '../models/product_page.dart';

sealed class ProductsState {
  const ProductsState();
}

final class ProductsInitial extends ProductsState {
  const ProductsInitial();
}

final class ProductsLoading extends ProductsState {
  const ProductsLoading();
}

final class ProductsLoaded extends ProductsState {
  const ProductsLoaded(this.page);
  final ProductPage page;
}

final class ProductsFailure extends ProductsState {
  const ProductsFailure(this.message);
  final String message;
}

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit(this._api) : super(const ProductsInitial());
  final ProductApi _api;
  ProductApi get api => _api;

  Future<void> load() async {
    emit(const ProductsLoading());
    try {
      emit(ProductsLoaded(await _api.getProducts()));
    } on Exception catch (error) {
      emit(ProductsFailure(error.toString()));
    }
  }
}

