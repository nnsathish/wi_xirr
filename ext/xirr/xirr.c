# include <math.h>
# include <time.h>
# include <stdio.h>
# include <ruby.h>

VALUE Xirr = Qnil;

void Init_xirr();
VALUE calculate(VALUE self, VALUE rb_amounts, VALUE rb_dates, VALUE guess);
double get_fx(double x, double amounts[], double investmentPreiods[], int numberOfTransactions);
double get_derivative_for_x(double x, double amounts[], double investmentPreiods[], int numberOfTransactions);

void Init_xirr() {
  Xirr = rb_const_get(rb_cObject, rb_intern("Xirr"));
  rb_define_module_function(Xirr, "calculate", calculate, 3);
}

VALUE calculate(VALUE self, VALUE rb_amounts, VALUE rb_dates, VALUE guess) {
  // Fixed variables
  int length = (int)RARRAY_LEN(rb_amounts);
  double delta = 1E-8;
  double investment_periods[length], amounts[length], dates[length];
  double min_date = 34028235E38;
  // Find min and max date and initialize c arrays
  for(int i = 0; i < length; i++) {
    amounts[i] = NUM2DBL(rb_ary_entry(rb_amounts, i));
    // Dates is the array containing the number of days since epoch
    dates[i] = floor(NUM2DBL(rb_ary_entry(rb_dates, i)) / 86400);
    if (dates[i] < min_date)
      min_date = dates[i];
  }
  // Find investment_periods
  for(int i = 0; i < length; i++)
    investment_periods[i] = (dates[i] - min_date);

  // Solving for 0 npv by bisection method
  // double left_guess = -49.99/365.0, right_guess = 49.99/365.0;
  // while((right_guess - left_guess) > (2 * delta)) {
  //   double mid = (right_guess + left_guess) / 2;
  //   if (get_fx(left_guess, amounts, investment_periods, length) * get_fx(mid, amounts, investment_periods, length) > 0)
  //     left_guess = mid;
  //   else
  //     right_guess = mid;
  // }
  // double irr = (left_guess + right_guess) / 2.0;

  // Solving for 0 npv by Newton's Method
  double init_guess = NUM2DBL(guess);
  double irr = init_guess, delta_x = 0.0;
  do {
    irr -= delta_x;
    if (irr == -1.0) {
      break;
    }
    double fx = get_fx(irr, amounts, investment_periods, length);
    double derivative_at_x = get_derivative_for_x(irr, amounts, investment_periods, length);
    if (derivative_at_x == 0.0) {
      irr = -1;
      break;
    }
    delta_x = fx / derivative_at_x;
  } while(fabs(delta_x) > delta);

  return DBL2NUM(pow(1 + irr, 365) - 1);
}

double get_fx(double x, double amounts[], double investmentPreiods[], int numberOfTransactions) {
  double fx = 0.0;
  for(int i = 0; i < numberOfTransactions; i++)
    fx += (amounts[i] / pow(1 + x, investmentPreiods[i]));
  return fx;
}

double get_derivative_for_x(double x, double amounts[], double investmentPreiods[], int numberOfTransactions) {
  double f_dash_x = 0.0;
  for(int i = 0; i < numberOfTransactions; i++)
    f_dash_x += (amounts[i] * investmentPreiods[i]) / pow(1 + x, investmentPreiods[i]);
  return -f_dash_x;
}
