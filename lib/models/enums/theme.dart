enum ThemeCategory {
  plain,
  animated,
  motivation,
  tropical,
  dimensions,
  urban,
  natural,
  abstract,
  architecture,
  anime,
  people,
  cosmos,
  flowsersAndPlants,
  luxury,
  textures,
  artDecor,
  seasonal,
  healthAndFitness,
  sunriseAndSunset,
  calm,
  blackAndWhite,
  illustration,
  animals,
  minimalism
}

//convert ThemeCategory to int
int themeCategoryToInt(ThemeCategory themeCategory) {
  switch (themeCategory) {
    case ThemeCategory.plain:
      return 0;
    case ThemeCategory.animated:
      return 1;
    case ThemeCategory.motivation:
      return 2;
    case ThemeCategory.tropical:
      return 3;
    case ThemeCategory.dimensions:
      return 4;
    case ThemeCategory.urban:
      return 5;
    case ThemeCategory.natural:
      return 6;
    case ThemeCategory.abstract:
      return 7;
    case ThemeCategory.architecture:
      return 8;
    case ThemeCategory.anime:
      return 9;
    case ThemeCategory.people:
      return 10;
    case ThemeCategory.cosmos:
      return 11;
    case ThemeCategory.flowsersAndPlants:
      return 12;
    case ThemeCategory.luxury:
      return 13;
    case ThemeCategory.textures:
      return 14;
    case ThemeCategory.artDecor:
      return 15;
    case ThemeCategory.seasonal:
      return 16;
    case ThemeCategory.healthAndFitness:
      return 17;
    case ThemeCategory.sunriseAndSunset:
      return 18;
    case ThemeCategory.calm:
      return 19;
    case ThemeCategory.blackAndWhite:
      return 20;
    case ThemeCategory.illustration:
      return 21;
    case ThemeCategory.animals:
      return 22;
    case ThemeCategory.minimalism:
      return 23;
    default:
      return 19;
  }
}

//convert ThemeCategory to String
String themeCategoryToString(ThemeCategory themeCategory) {
  switch (themeCategory) {
    case ThemeCategory.plain:
      return 'plain';
    case ThemeCategory.animated:
      return 'animated';
    case ThemeCategory.motivation:
      return 'motivation';
    case ThemeCategory.tropical:
      return 'tropical';
    case ThemeCategory.dimensions:
      return 'dimensions';
    case ThemeCategory.urban:
      return 'Urban';
    case ThemeCategory.natural:
      return 'natural';
    case ThemeCategory.abstract:
      return 'abstract';
    case ThemeCategory.architecture:
      return 'architecture';
    case ThemeCategory.anime:
      return 'anime';
    case ThemeCategory.people:
      return 'people';
    case ThemeCategory.cosmos:
      return 'cosmos';
    case ThemeCategory.flowsersAndPlants:
      return 'flowsersAndPlants';
    case ThemeCategory.luxury:
      return 'luxury';
    case ThemeCategory.textures:
      return 'textures';
    case ThemeCategory.artDecor:
      return 'artDecor';
    case ThemeCategory.seasonal:
      return 'seasonal';
    case ThemeCategory.healthAndFitness:
      return 'healthAndFitness';
    case ThemeCategory.sunriseAndSunset:
      return 'sunriseAndSunset';
    case ThemeCategory.calm:
      return 'calm';
    case ThemeCategory.blackAndWhite:
      return 'blackAndWhite';
    case ThemeCategory.illustration:
      return 'illustration';
    case ThemeCategory.animals:
      return 'animals';
    case ThemeCategory.minimalism:
      return 'minimalism';
    default:
      return 'calm';
  }
}

//convert ThemeCategory to Lable String
String themeCategoryToLabel(ThemeCategory themeCategory) {
  switch (themeCategory) {
    case ThemeCategory.plain:
      return 'Plain';
    case ThemeCategory.animated:
      return 'Animated';
    case ThemeCategory.motivation:
      return 'Motivation';
    case ThemeCategory.tropical:
      return 'Tropical';
    case ThemeCategory.dimensions:
      return 'Dimensions';
    case ThemeCategory.urban:
      return 'Urban';
    case ThemeCategory.natural:
      return 'Natural';
    case ThemeCategory.abstract:
      return 'Abstract';
    case ThemeCategory.architecture:
      return 'Architecture';
    case ThemeCategory.anime:
      return 'Anime';
    case ThemeCategory.people:
      return 'People';
    case ThemeCategory.cosmos:
      return 'Cosmos';
    case ThemeCategory.flowsersAndPlants:
      return 'Flowsers & Plants';
    case ThemeCategory.luxury:
      return 'Luxury';
    case ThemeCategory.textures:
      return 'Textures';
    case ThemeCategory.artDecor:
      return 'Art Decor';
    case ThemeCategory.seasonal:
      return 'Seasonal';
    case ThemeCategory.healthAndFitness:
      return 'Health & Fitness';
    case ThemeCategory.sunriseAndSunset:
      return 'Sunrise & Sunset';
    case ThemeCategory.calm:
      return 'Calm';
    case ThemeCategory.blackAndWhite:
      return 'Black & White';
    case ThemeCategory.illustration:
      return 'Illustration';
    case ThemeCategory.animals:
      return 'Animals';
    case ThemeCategory.minimalism:
      return 'Minimalism';
    default:
      return 'Calm';
  }
}

//convert int to ThemeCategory
ThemeCategory intToThemeCategory(int themeCategory) {
  switch (themeCategory) {
    case 0:
      return ThemeCategory.plain;
    case 1:
      return ThemeCategory.animated;
    case 2:
      return ThemeCategory.motivation;
    case 3:
      return ThemeCategory.tropical;
    case 4:
      return ThemeCategory.dimensions;
    case 5:
      return ThemeCategory.urban;
    case 6:
      return ThemeCategory.natural;
    case 7:
      return ThemeCategory.abstract;
    case 8:
      return ThemeCategory.architecture;
    case 9:
      return ThemeCategory.anime;
    case 10:
      return ThemeCategory.people;
    case 11:
      return ThemeCategory.cosmos;
    case 12:
      return ThemeCategory.flowsersAndPlants;
    case 13:
      return ThemeCategory.luxury;
    case 14:
      return ThemeCategory.textures;
    case 15:
      return ThemeCategory.artDecor;
    case 16:
      return ThemeCategory.seasonal;
    case 17:
      return ThemeCategory.healthAndFitness;
    case 18:
      return ThemeCategory.sunriseAndSunset;
    case 19:
      return ThemeCategory.calm;
    case 20:
      return ThemeCategory.blackAndWhite;
    case 21:
      return ThemeCategory.illustration;
    case 22:
      return ThemeCategory.animals;
    case 23:
      return ThemeCategory.minimalism;
    default:
      return ThemeCategory.calm;
  }
}

enum ThemeType { free, premium }

//convert ThemeType to String
String themeTypeToString(ThemeType themeType) {
  switch (themeType) {
    case ThemeType.free:
      return 'free';
    case ThemeType.premium:
      return 'premium';
    default:
      return 'free';
  }
}

//convert String to ThemeType
ThemeType stringToThemeType(String themeType) {
  switch (themeType) {
    case 'free':
      return ThemeType.free;
    case 'premium':
      return ThemeType.premium;
    default:
      return ThemeType.free;
  }
}
