import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/product_api.dart';
import '../models/product.dart';

sealed class ProductDetailsState {
  const ProductDetailsState();
}

final class DetailsLoading extends ProductDetailsState {
  const DetailsLoading();
}

final class DetailsLoaded extends ProductDetailsState {
  const DetailsLoaded(this.product);
  final Product product;
}

final class DetailsFailure extends ProductDetailsState {
  const DetailsFailure(this.message);
  final String message;
}

class DetailsCubit extends Cubit<ProductDetailsState> {
  DetailsCubit(this._api) : super(const DetailsLoading());
  final ProductApi _api;

  Future<void> load(int id) async {
    emit(const DetailsLoading());
    try {
      emit(DetailsLoaded(await _api.getProduct(id)));
    } on Exception catch (error) {
      emit(DetailsFailure(error.toString()));
    }
  }
}
