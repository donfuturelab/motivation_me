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

enum CategoryEnum {
  love,
  life,
  inspirational,
  humor,
  philosophy,
  god,
  truth,
  romance,
  happiness,
  hope,
  faith,
  wisdom,
  religion,
  success,
  relationships,
  time,
  science,
  education,
  knowledge,
  spirituality,
  failure,
  confidence,
  choices,
  change,
  dreams,
  excellence,
  freedom,
  fear,
  leadership,
  productivity,
  courage,
  death,
  future,
  kindness,
  pain,
}

String convertCategoryEnumToString(CategoryEnum categoryEnum) {
  switch (categoryEnum) {
    case CategoryEnum.love:
      return 'love';
    case CategoryEnum.life:
      return 'life';
    case CategoryEnum.inspirational:
      return 'inspirational';
    case CategoryEnum.humor:
      return 'humor';
    case CategoryEnum.philosophy:
      return 'philosophy';
    case CategoryEnum.god:
      return 'god';
    case CategoryEnum.truth:
      return 'truth';
    case CategoryEnum.wisdom:
      return 'wisdon';
    case CategoryEnum.romance:
      return 'romance';
    case CategoryEnum.happiness:
      return 'happiness';
    case CategoryEnum.hope:
      return 'hope';
    case CategoryEnum.faith:
      return 'faith';
    case CategoryEnum.religion:
      return 'religion';
    case CategoryEnum.success:
      return 'success';
    case CategoryEnum.relationships:
      return 'relationships';
    case CategoryEnum.time:
      return 'time';
    case CategoryEnum.science:
      return 'science';
    case CategoryEnum.education:
      return 'education';
    case CategoryEnum.knowledge:
      return 'knowledge';
    case CategoryEnum.spirituality:
      return 'spirituality';
    case CategoryEnum.failure:
      return 'failure';
    case CategoryEnum.confidence:
      return 'confidence';
    case CategoryEnum.choices:
      return 'choices';
    case CategoryEnum.change:
      return 'change';
    case CategoryEnum.dreams:
      return 'dreams';
    case CategoryEnum.excellence:
      return 'excellence';
    case CategoryEnum.freedom:
      return 'freedom';
    case CategoryEnum.fear:
      return 'fear';
    case CategoryEnum.leadership:
      return 'leadership';
    case CategoryEnum.productivity:
      return 'productivity';
    case CategoryEnum.courage:
      return 'courage';
    case CategoryEnum.death:
      return 'death';
    case CategoryEnum.future:
      return 'future';
    case CategoryEnum.kindness:
      return 'kindness';
    case CategoryEnum.pain:
      return 'pain';
  }
}
