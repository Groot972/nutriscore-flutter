class Product {
  final String barcode;
  final String? name;
  final String? altName;
  final String? picture;
  final String? quantity;
  final List<String>? brands;
  final List<String>? manufacturingCountries;
  final ProductNutriscore? nutriScore;
  final ProductNovaScore? novaScore;
  final ProductEcoScore? ecoScore;
  final List<String>? ingredients;
  final List<String>? traces;
  final List<String>? allergens;
  final Map<String, String>? additives;
  final NutrientLevels? nutrientLevels;
  final NutritionFacts? nutritionFacts;
  final bool? ingredientsFromPalmOil;

  Product(
      {required this.barcode,
        this.name,
        this.altName,
        this.picture,
        this.quantity,
        this.brands,
        this.manufacturingCountries,
        this.nutriScore,
        this.novaScore,
        this.ecoScore,
        this.ingredients,
        this.traces,
        this.allergens,
        this.additives,
        this.nutrientLevels,
        this.nutritionFacts,
        this.ingredientsFromPalmOil});

  /*factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      barcode: json['barcode'] as String,
      name: json['name'] as String?,
      altName: json['altName'] as String?,
      picture: json['picture'] as String?,
      quantity: json['quantity'] as String?,
      brands: (json['brands'] as List<dynamic>?)?.map((e) => e as String).toList(),
      manufacturingCountries: (json['manufacturingCountries'] as List<dynamic>?)?.map((e) => e as String).toList(),
      nutriScore: ProductNutriscore(json['nutriScore'] as String),
      novaScore: ProductNovaScore(json['novaScore'] as String?),
      ecoScore: ProductEcoScore(json['ecoScore'] as String?),
      ingredients: (json['ingredients'] as List<dynamic>?)?.map((e) => e as String).toList(),
      traces: (json['traces'] as List<dynamic>?)?.map((e) => e as String).toList(),
      allergens: (json['allergens'] as List<dynamic>?)?.map((e) => e as String).toList(),
      additives: json['additives'] != null ? Map<String, String>.from(json['additives'] as Map) : null,
      nutrientLevels: NutrientLevels(json['nutrientLevels'] as Map<String, dynamic>?),
      nutritionFacts: NutritionFacts(json['nutritionFacts'] as Map<String, dynamic>?),
      ingredientsFromPalmOil: json['ingredientsFromPalmOil'] as bool?,
    );
  } */
}


class NutritionFacts {
  final String servingSize;
  final Nutriment? calories;
  final Nutriment? fat;
  final Nutriment? saturatedFat;
  final Nutriment? carbohydrate;
  final Nutriment? sugar;
  final Nutriment? fiber;
  final Nutriment? proteins;
  final Nutriment? sodium;
  final Nutriment? salt;
  final Nutriment? energy;

  NutritionFacts(
      {required this.servingSize,
        this.calories,
        this.fat,
        this.saturatedFat,
        this.carbohydrate,
        this.sugar,
        this.fiber,
        this.proteins,
        this.sodium,
        this.salt,
        this.energy});
}

class Nutriment {
  final String unit;
  final dynamic perServing;
  final dynamic per100g;

  Nutriment({required this.unit, this.perServing, this.per100g});
}

class NutrientLevels {
  final String? salt;
  final String? saturatedFat;
  final String? sugars;
  final String? fat;

  NutrientLevels({this.salt, this.saturatedFat, this.sugars, this.fat});
}

enum ProductNutriscore {
  A("a"),
  B("b"),
  C("c"),
  D("d"),
  E("e");

  final String letter;

  const ProductNutriscore(this.letter);
}

enum ProductNovaScore { Group1, Group2, Group3, Group4 }

enum ProductEcoScore { A, B, C, D, E }