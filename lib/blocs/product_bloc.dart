// Event
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutriscore_flutter/Product.dart';
import 'package:nutriscore_flutter/manager.dart';

abstract class ProductEvent {
  const ProductEvent();
}

class LoadProductEvent extends ProductEvent {
  final String barcode;

  LoadProductEvent(this.barcode) : assert(barcode != '');
}

// State
abstract class ProductState {
  const ProductState();
}

class LoadingProductState extends ProductState {
  const LoadingProductState();
}

class LoadedProductState extends ProductState {
  final Product product;

  const LoadedProductState(this.product);
}

class ErrorProductState extends ProductState {
  final Exception error;

  const ErrorProductState(this.error);
}

// BloC
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  // Valeur initiale
  ProductBloc() : super(const LoadingProductState()) {
    on<LoadProductEvent>(_onLoadProduct as EventHandler<LoadProductEvent, ProductState>);
  }

  Future<void> _onLoadProduct(handler, emitter, LoadProductEvent event) async {
    emitter(const LoadingProductState());

    // TODO Faire de la requête
    final product = await NetworkManager().fetchProduct(event.barcode);

      emitter(LoadedProductState(product));
      await Future.delayed(const Duration(seconds: 5));


  }
}
