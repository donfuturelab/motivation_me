enum QuoteSource { defaultQuote, userQuote }

//convert QuoteSource to String
String quoteSourceToString(QuoteSource quoteSource) {
  switch (quoteSource) {
    case QuoteSource.defaultQuote:
      return 'default';
    case QuoteSource.userQuote:
      return 'user';
    default:
      return 'default';
  }
}

//convert String to QuoteSource
QuoteSource stringToQuoteSource(String quoteSource) {
  switch (quoteSource) {
    case 'default':
      return QuoteSource.defaultQuote;
    case 'user':
      return QuoteSource.userQuote;
    default:
      return QuoteSource.defaultQuote;
  }
}
