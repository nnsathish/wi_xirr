# include <math.h>
# include <time.h>
# include <stdio.h>
# include <ruby.h>

VALUE Xirr = Qnil;

void Init_xirr();
VALUE calculate(VALUE self, VALUE rb_amounts, VALUE rb_dates);
double sum_npv(double rate, double amounts[], double investmentPeriods[], int numberOfTransactions);

void Init_xirr() {
  Xirr = rb_const_get(rb_cObject, rb_intern("Xirr"));
  rb_define_module_function(Xirr, "calculate", calculate, 2);
}

VALUE calculate(VALUE self, VALUE rb_amounts, VALUE rb_dates) {
  // Fixed variables
  int length = (int)RARRAY_LEN(rb_amounts);
  double delta = 1E-8, left_guess = -50.0/365.0, right_guess = 50.0/365.0;
  double investment_periods[length], amounts[length], dates[length];
  double min_date = 34028235E38;
  // Find min and max date and initialize c arrays
  for(int i = 0; i < length; i++) {
    amounts[i] = NUM2DBL(rb_ary_entry(rb_amounts, i));
    // Dates is the array containing the number of days since epoch
    dates[i] = floor(NUM2DBL(rb_ary_entry(rb_dates, i))/86400);
    if (dates[i] < min_date)
      min_date = dates[i];
  }
  // Find investment_periods
  for(int i = 0; i < length; i++) 
    investment_periods[i] = (dates[i] - min_date);
  // Solving for 0 npv
  while((right_guess - left_guess) > (2 * delta)) {
    double mid = (right_guess + left_guess ) / 2;
    if (sum_npv(left_guess, amounts, investment_periods, length) * sum_npv(mid, amounts, investment_periods, length) > 0)
      left_guess = mid;
    else
      right_guess = mid;
  }
  double irr = (left_guess + right_guess) / 2.0;
  return DBL2NUM(pow(1 + irr, 365) - 1);
}

double sum_npv(double rate, double amounts[], double investmentPeriods[], int numberOfTransactions) {
  double sum_of_npvs = 0.0;
  for(int i = 0; i < numberOfTransactions; i++)
    sum_of_npvs += amounts[i] / pow(1 + rate, investmentPeriods[i]);
  return sum_of_npvs;
}
