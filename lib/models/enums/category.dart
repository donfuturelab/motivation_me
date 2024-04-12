enum CategoryType { free, premium }

//convert CategoryType to String
String categoryTypeToString(CategoryType categoryType) {
  switch (categoryType) {
    case CategoryType.free:
      return 'free';
    case CategoryType.premium:
      return 'premium';
    default:
      return 'premium';
  }
}

//convert String to CategoryType
CategoryType categoryTypeFromString(String categoryType) {
  switch (categoryType) {
    case 'free':
      return CategoryType.free;
    case 'premium':
      return CategoryType.premium;
    default:
      return CategoryType.premium;
  }
}

enum SelectCategoryStatus { success, notSubscribed, alreadyAdded }
