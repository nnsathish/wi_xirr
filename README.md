# WI-XIRR

A fast XIRR calulator for Ruby

## Introduction

This gem uses a pure C implementation of the newtonian method for XIRR calculation.

It also uses native extensions instead of ffi so that deployed containers need not have a C compiler to run the calculation

## Installation

In your Gemfile, add

    gem 'wi_xirr'

And then run

    bundle install

## Usage

    include WiXirr
    
    # Cash Flow
    amounts=[[1000, -600, -6000] 
    dates=[Time.parse("1985-01-01").to_f, Time.parse("1990-01-01").to_f, Time.parse("1995-01-01").to_f] 
    max_iterations=1000
    initial_guess=0

    result=WiXirr.calculate(amounts,dates,initial_guess,max_iterations)

## Supported Versions

Ruby 2.5

## References

This gem was derived from the xirr gem, which supports both newtonian and bisection methods and uses ffi for inline compilation, which might be a better fit based on your needs - https://github.com/grafeno-sa/xirr

## Contributing

- Fork it 
- Create your feature branch (git checkout -b my-new-feature)
- Run specs (rake default)
- Commit your changes (git commit -am 'Add some feature')
- Push to the branch (git push origin my-new-feature)
- Create a new Pull Request


  



