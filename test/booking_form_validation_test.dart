import 'package:dental_booking/ui/features/bookings/views/booking_form_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('required fields reject blanks', () {
    expect(requiredField(null), 'Required');
    expect(requiredField('  '), 'Required');
    expect(requiredField('Ada'), isNull);
  });

  test('insurance name required only when Yes', () {
    expect(validateInsuranceName('', hasInsurance: false), isNull);
    expect(validateInsuranceName('', hasInsurance: true), 'Required');
    expect(validateInsuranceName('PhilHealth', hasInsurance: true), isNull);
  });

  test('price accepts empty or a number', () {
    expect(validatePrice(''), isNull);
    expect(validatePrice('2500.50'), isNull);
    expect(validatePrice('abc'), 'Enter a valid amount');
    expect(validatePrice('-1'), 'Must be positive');
  });
}
