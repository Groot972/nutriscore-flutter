import 'package:flutter/material.dart';
import 'package:nutriscore_flutter/Product.dart';
import 'package:nutriscore_flutter/app_icons.dart';
import 'package:nutriscore_flutter/app_images.dart';
import 'package:nutriscore_flutter/Colors.dart';
import 'package:nutriscore_flutter/vues/nutritional_value.dart';
import 'package:share_plus/share_plus.dart';

import '../blocs/product_bloc.dart';

class ProductContainer extends InheritedWidget {
  final Product product;

  const ProductContainer({
    Key? key,
    required Widget child,
    required this.product,
  }) : super(key: key, child: child);

  static ProductContainer of(BuildContext context) {
    final ProductContainer? result =
    context.dependOnInheritedWidgetOfExactType<ProductContainer>();
    assert(result != null, 'No ProductContainer found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(ProductContainer oldWidget) {
    return product != oldWidget.product;
  }
}

//region Ecran de détails
class ProductDetails extends StatefulWidget {
  const ProductDetails({Key? key}) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final ScrollController _controller = ScrollController();
  final ProductBloc _productBloc = ProductBloc();
  ProductDetailsTab _currentTab = ProductDetailsTab.info;

  @override
  Widget build(BuildContext context) {
    final Widget child;

    switch (_currentTab) {
      case ProductDetailsTab.info:
        child = const ProductInfo();
        break;
      case ProductDetailsTab.nutrition:
        child = const ProductNutrition();
        break;
      case ProductDetailsTab.nutritionalValues:
        child = ProductNutritionalValues(libelle: _productBloc.name);
        break;
      case ProductDetailsTab.summary:
        child = const ProductSummary();
        break;
    }

    return PrimaryScrollController(
      controller: _controller,
      child: ProductContainer(
        product: ,
        child: Scaffold(
          body: Stack(
            children: [
              Positioned.fill(child: child),
              const Align(
                alignment: AlignmentDirectional.topStart,
                child: _HeaderIcon(
                  icon: AppIcons.close,
                  tooltip: 'Fermer l\'écran',
                ),
              ),
               Align(
                alignment: AlignmentDirectional.topEnd,
                child: _HeaderIcon(
                  icon: AppIcons.share,
                  tooltip: 'Partager',
                  onPressed: () {

                    Share.share(
                       'https://fr.openfoodfacts.org/produit/3245412580048');
                  }
                ),
              ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            onTap: (int selectedPosition) {
              ProductDetailsTab newTab =
              ProductDetailsTab.values[selectedPosition];

              if (newTab != _currentTab) {
                if (_controller.hasClients) {
                  _controller.jumpTo(0.0);
                }

                setState(() {
                  _currentTab = newTab;
                });
              }
            },
            items: ProductDetailsTab.values.map((e) {
              String? label;
              IconData? icon;

              switch (e) {
                case ProductDetailsTab.info:
                  icon = AppIcons.tab_barcode;
                  label = "Fiche";
                  break;
                case ProductDetailsTab.nutritionalValues:
                  icon = AppIcons.tab_fridge;
                  label = "Caractéristiques";
                  break;
                case ProductDetailsTab.nutrition:
                  icon = AppIcons.tab_nutrition;
                  label = "Nutrition";
                  break;
                case ProductDetailsTab.summary:
                  icon = AppIcons.tab_array;
                  label = "Tableau";
              }

              if (label == null || icon == null) {
                throw Exception("Tab $e not implemented!");
              }

              return BottomNavigationBarItem(
                icon: Icon(icon),
                label: label,

              );
            }).toList(growable: false),
            currentIndex: _currentTab.index,
          ),
        ),
      ),
    );
  }



  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

enum ProductDetailsTab {
  info,
  nutrition,
  nutritionalValues,
  summary,
}

//endregion

//region Onglet Info

class ProductInfo extends StatefulWidget {
  static const double kImageHeight = 300.0;

  const ProductInfo({Key? key}) : super(key: key);

  @override
  State<ProductInfo> createState() => _ProductInfoState();
}

double _scrollProgress(BuildContext context) {
  ScrollController? controller = PrimaryScrollController.of(context);
  return !controller.hasClients
      ? 0
      : (controller.position.pixels / ProductInfo.kImageHeight).clamp(0, 1);
}

class _ProductInfoState extends State<ProductInfo> {
  double _currentScrollProgress = 0.0;

  // Quand on scroll, on redraw pour changer la couleur de l'image
  void _onScroll() {
    if (_currentScrollProgress != _scrollProgress(context)) {
      setState(() {
        _currentScrollProgress = _scrollProgress(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController =
    PrimaryScrollController.of(context);

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        _onScroll();
        return false;
      },
      child: Stack(children: [
        Image.network(
          ProductContainer.of(context).product.picture ?? '',
          width: double.infinity,
          height: ProductInfo.kImageHeight,
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
                margin: const EdgeInsetsDirectional.only(
                  top: ProductInfo.kImageHeight - 30.0,
                ),
                child: const _Body(),
              ),
            ),
          ),
        ),
      ]),
    );
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
          _Scores(),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _kHorizontalPadding,
              vertical: _kVerticalPadding,
            ),
            child: _Info(),
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
    final Product product = ProductContainer.of(context).product;

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
            'Cassegrain',
            style: textTheme.displayMedium,
          ),
          const SizedBox(
            height: 8.0,
          ),
        ],
        if (product.altName != null)
          Text(
            product.altName!,
            style: textTheme.headlineMedium,
          ),
      ],
    );
  }
}

class _Scores extends StatelessWidget {
  static const double _horizontalPadding = _Body._kHorizontalPadding;
  static const double _verticalPadding = 18.0;

  const _Scores({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.gray1,
      width: double.infinity,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: _verticalPadding,
            horizontal: _horizontalPadding,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                flex: 44,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(end: 5.0),
                    child: _Nutriscore(
                      nutriscore: ProductNutriscore.A,
                    ),
                  ),
                ),
              ),
              Container(
                width: 1.0,
                height: 100.0,
                color: Theme.of(context).dividerColor,
              ),
              const Expanded(
                flex: 66,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(start: 25.0),
                    child: _NovaGroup(
                      novaScore: ProductNovaScore.Group1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(
          height: 1.0,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(
            vertical: _verticalPadding,
            horizontal: _horizontalPadding,
          ),
          child: _EcoScore(
            ecoScore: ProductEcoScore.D,
          ),
        ),
      ]),
    );
  }
}

class _Nutriscore extends StatelessWidget {
  final ProductNutriscore nutriscore;

  const _Nutriscore({
    required this.nutriscore,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nutri-Score',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(
          height: 5.0,
        ),
        Image.asset(
          _findAssetName(),
          width: 100.0,
        ),
      ],
    );
  }

  String _findAssetName() {
    switch (nutriscore) {
      case ProductNutriscore.A:
        return AppImages.nutriscoreA;
      case ProductNutriscore.B:
        return AppImages.nutriscoreB;
      case ProductNutriscore.C:
        return AppImages.nutriscoreC;
      case ProductNutriscore.D:
        return AppImages.nutriscoreD;
      case ProductNutriscore.E:
        return AppImages.nutriscoreE;
      default:
        throw Exception('Unknown nutriscore value!');
    }
  }
}

class _NovaGroup extends StatelessWidget {
  final ProductNovaScore novaScore;

  const _NovaGroup({
    required this.novaScore,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Groupe Nova',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontSize: 16.0,
          ),
        ),
        const SizedBox(
          height: 5.0,
        ),
        Text(
          _findLabel(),
          style: const TextStyle(
            color: AppColors.gray2,
          ),
        ),
      ],
    );
  }

  String _findLabel() {
    switch (novaScore) {
      case ProductNovaScore.Group1:
        return 'Aliments non transformés ou transformés minimalement';
      case ProductNovaScore.Group2:
        return 'Ingrédients culinaires transformés';
      case ProductNovaScore.Group3:
        return 'Aliments transformés';
      case ProductNovaScore.Group4:
        return 'Produits alimentaires et boissons ultra-transformés';
      default:
        throw Exception('Unknown nova group!');
    }
  }
}

class _EcoScore extends StatelessWidget {
  final ProductEcoScore ecoScore;

  const _EcoScore({
    required this.ecoScore,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EcoScore',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(
          height: 5.0,
        ),
        Row(
          children: [
            Icon(
              _findIcon(),
              color: _findIconColor(),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Text(
              _findLabel(),
              style: const TextStyle(
                color: AppColors.gray2,
              ),
            ),
          ],
        ),
      ],
    );
  }

  IconData _findIcon() {
    switch (ecoScore) {
      case ProductEcoScore.A:
        return AppIcons.ecoscore_a;
      case ProductEcoScore.B:
        return AppIcons.ecoscore_b;
      case ProductEcoScore.C:
        return AppIcons.ecoscore_c;
      case ProductEcoScore.D:
        return AppIcons.ecoscore_d;
      case ProductEcoScore.E:
        return AppIcons.ecoscore_e;
      default:
        throw Exception('Unknown nova group!');
    }
  }

  Color _findIconColor() {
    switch (ecoScore) {
      case ProductEcoScore.A:
        return AppColors.ecoScoreA;
      case ProductEcoScore.B:
        return AppColors.ecoScoreB;
      case ProductEcoScore.C:
        return AppColors.ecoScoreC;
      case ProductEcoScore.D:
        return AppColors.ecoScoreD;
      case ProductEcoScore.E:
        return AppColors.ecoScoreE;
      default:
        throw Exception('Unknown nova group!');
    }
  }

  String _findLabel() {
    switch (ecoScore) {
      case ProductEcoScore.A:
        return 'Très faible impact environnemental';
      case ProductEcoScore.B:
        return 'Faible impact environnemental';
      case ProductEcoScore.C:
        return 'Impact modéré sur l\'environnement';
      case ProductEcoScore.D:
        return 'Impact environnemental élevé';
      case ProductEcoScore.E:
        return 'Impact environnemental très élevé';
    }
  }
}

class _Info extends StatelessWidget {
  const _Info({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const _ProductItemValue(
          label: 'Quantité',
          value: '200g (égoutté 130g)',
        ),
        const _ProductItemValue(
          label: 'Vendu',
          value: 'France',
          includeDivider: false,
        ),
        const SizedBox(
          height: 15.0,
        ),
        Row(
          children: const [
            Expanded(
              flex: 40,
              child: _ProductBubble(
                label: 'Végétalien',
                value: _ProductBubbleValue.on,
              ),
            ),
            Spacer(
              flex: 10,
            ),
            Expanded(
              flex: 40,
              child: _ProductBubble(
                label: 'Végétarien',
                value: _ProductBubbleValue.off,
              ),
            ),
          ],
        )
      ],
    );
  }
}

class _ProductItemValue extends StatelessWidget {
  final String label;
  final String value;
  final bool includeDivider;

  const _ProductItemValue({
    required this.label,
    required this.value,
    this.includeDivider = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
        if (includeDivider) const Divider(height: 1.0)
      ],
    );
  }
}

class _ProductBubble extends StatelessWidget {
  final String label;
  final _ProductBubbleValue value;

  const _ProductBubble({required this.label, required this.value, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.blueLight,
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 15.0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            value == _ProductBubbleValue.on
                ? AppIcons.checkmark
                : AppIcons.close,
            color: AppColors.white,
          ),
          const SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: AppColors.white),
            ),
          )
        ],
      ),
    );
  }
}

enum _ProductBubbleValue { on, off }

//endregion

// region Onglet Nutrition

class ProductNutrition extends StatelessWidget {
  const ProductNutrition({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder(child: Center(child: Text('Nutrition')));
  }
}

//endregion

class ProductNutritionalValues extends StatelessWidget {
  final String? libelle;

  ProductNutritionalValues({Key? key, required this.libelle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Product product = ProductContainer.of(context).product;
    final ScrollController scrollController = PrimaryScrollController.of(context);

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        // Gérer les notifications de défilement ici si nécessaire
        return true;
      },
      child: Stack(
        children: [
          Image.network(
            product.picture ?? '',
            width: double.infinity,
            height: ProductInfo.kImageHeight,
            fit: BoxFit.cover,
            colorBlendMode: BlendMode.srcATop,
          ),
          Positioned.fill(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Scrollbar(
                controller: scrollController,
                trackVisibility: true,
                child: Container(
                  margin: const EdgeInsetsDirectional.only(
                    top: ProductInfo.kImageHeight - 30.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CaracteristicsWidget(ingredients: product.ingredients),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CaracteristicsWidget extends StatelessWidget {
  final List<String>? ingredients;

  const CaracteristicsWidget({Key? key, required this.ingredients}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSection('Ingrédients', ingredients!),
      ],
    );
  }

  Widget _buildSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: AppColors.gray1,
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.blueDark,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(items[index]),
            );
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}


//endregion

//region Onglet Summary

class ProductSummary extends StatelessWidget {
  const ProductSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder(child: Center(child: Text('Summary')));
  }
}

//endregion
