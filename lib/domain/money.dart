import 'package:intl/intl.dart';

// The only place in the entire app where cents become a display string.
// Call this from the UI layer; never do the division anywhere else.

String formatCents(int cents) {

  double moneyDollars = cents/100;
  String sgdDollars = NumberFormat.currency(
    locale: 'en_SG',
    name: 'SGD ', // ISO 4217 code for Singapore Dollar
  ).format(moneyDollars);

  return sgdDollars;


}

// For chart rendering only — returns a double, not a display string that is in hundreds and not in floating point.
double centsToChartValue(int cents) {
  return cents/100.0;
}
