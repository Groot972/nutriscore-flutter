

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nutriscore_flutter/Product.dart';

import '../blocs/product_bloc.dart';

class ProductNutritionalValues extends StatefulWidget {
  static const double kImageHeight = 300.0;

  const ProductNutritionalValues({Key? key}) : super(key: key);

  @override
  State<ProductNutritionalValues> createState() => _ProductNutritionalValuesState();
}

class _ProductNutritionalValuesState extends State<ProductNutritionalValues> {
  double _currentScrollProgress = 0.0;

  void _onScroll() {
    final double newScrollProgress = _scrollProgress(context);
    if (_currentScrollProgress != newScrollProgress) {
      setState(() {
        _currentScrollProgress = newScrollProgress;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = PrimaryScrollController.of(context);

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        _onScroll();
        return false;
      },
      child: Stack(
        children: [
          Image.network(
            product.picture ?? '',
            width: double.infinity,
            height: ProductNutritionalValues.kImageHeight,
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(_currentScrollProgress),
            colorBlendMode: BlendMode.srcATop,
          ),
          Positioned.fill(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Scrollbar(
                controller: scrollController,
                trackVisibility: true,
                child: Container(
                  margin: const EdgeInsets.only(
                    top: ProductNutritionalValues.kImageHeight - 30.0,
                  ),
                  child: const _Body(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _scrollProgress(BuildContext context) {
    final ScrollController? controller = PrimaryScrollController.of(context);
    return !controller!.hasClients ? 0 : (controller.position.pixels / ProductNutritionalValues.kImageHeight).clamp(0, 1);
  }
}

class _HeaderIcon extends StatefulWidget {
  final IconData icon;
  final String? tooltip;
  final VoidCallback? onPressed;

  const _HeaderIcon({
    required this.icon,
    this.tooltip,
    // ignore: unused_element
    this.onPressed,
  });

  @override
  State<_HeaderIcon> createState() => _HeaderIconState();
}

class _HeaderIconState extends State<_HeaderIcon> {
  double _opacity = 0.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    PrimaryScrollController.of(context).addListener(_onScroll);
  }

  void _onScroll() {
    double newOpacity = _scrollProgress(context);

    if (newOpacity != _opacity) {
      setState(() {
        _opacity = newOpacity;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          type: MaterialType.transparency,
          child: Tooltip(
            message: widget.tooltip,
            child: InkWell(
              onTap: widget.onPressed ?? () {},
              customBorder: const CircleBorder(),
              child: Ink(
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                  Theme.of(context).primaryColorLight.withOpacity(_opacity),
                ),
                child: Icon(
                  widget.icon,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  static const double _kHorizontalPadding = 20.0;
  static const double _kVerticalPadding = 30.0;

  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadiusDirectional.only(
          topStart: Radius.circular(16.0),
          topEnd: Radius.circular(16.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _kHorizontalPadding,
              vertical: _kVerticalPadding,
            ),
            child: _Header(),
          ),
          //_Scores(),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _kHorizontalPadding,
              vertical: _kVerticalPadding,
            ),
            child: _Infos(),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return BlocBuilder<ProductBloc, ProductState>(
        builder: (BuildContext context, ProductState state) {
          final Product product = (state as LoadedProductState).product;

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (product.name != null)
                Text(
                  product.name!,
                  style: textTheme.displayLarge,
                ),
              const SizedBox(
                height: 3.0,
              ),
              if (product.brands != null) ...[
                Text(
                  product.brands!.join(", "),
                  style: textTheme.displayMedium,
                ),
                const SizedBox(
                  height: 8.0,
                ),
              ],
            ],
          );
        });
  }
}

