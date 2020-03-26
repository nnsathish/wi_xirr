require 'spec_helper'

describe WiXirr do
  context 'for a realistic, good investment' do
    let(:amounts) { [1000, -600, -6000] }
    let(:dates) { [Time.parse("1985-01-01").to_f, Time.parse("1990-01-01").to_f, Time.parse("1995-01-01").to_f] }
    it 'should calculate the XIRR' do
      result = WiXirr.calculate(amounts, dates, 0)
      expect(result).to be_within(0.00001).of(0.225683)
    end
  end

  context 'for a realistic, bad investment' do
    let(:amounts) { [1000, -600, -200] }
    let(:dates) { [Time.parse("1985-01-01").to_f, Time.parse("1990-01-01").to_f, Time.parse("1995-01-01").to_f] }
    it 'should calculate the XIRR' do
      result = WiXirr.calculate(amounts, dates, 0)
      expect(result).to be_within(0.00001).of(-0.0346)
    end
  end

  context 'where sorting of transactions by date is not necessary' do
    let(:amounts) { [-200, -600, 1000] }
    let(:dates) { [Time.parse("1995-01-01").to_f, Time.parse("1990-01-01").to_f, Time.parse("1985-01-01").to_f] }
    it 'should calculate the XIRR' do
      result = WiXirr.calculate(amounts, dates, 0)
      expect(result).to be_within(0.00001).of(-0.0346)
    end
  end

  context 'for all failure scenarios' do
    context 'for all negative amounts' do
      let(:amounts) { [-1000, -600, -6000] }
      let(:dates) { [Time.parse("1985-01-01").to_f, Time.parse("1990-01-01").to_f, Time.parse("1995-01-01").to_f] }
      it 'should return -1' do
        result = WiXirr.calculate(amounts, dates, 0)
        expect(result).to be(-1.0)
      end
    end

    context 'for all positive amounts' do
      let(:amounts) { [1000, 600, 6000] }
      let(:dates) { [Time.parse("1985-01-01").to_f, Time.parse("1990-01-01").to_f, Time.parse("1995-01-01").to_f] }
      it 'should return -1' do
        result = WiXirr.calculate(amounts, dates, 0)
        expect(result).to be(-1.0)
      end
    end

    context 'when all the dates are the same' do
      let(:amounts) { [1000, -600, -600] }
      let(:dates) { [Time.parse("2020-01-01").to_f, Time.parse("2020-01-01").to_f, Time.parse("2020-01-01").to_f] }
      it 'should return -1' do
        result = WiXirr.calculate(amounts, dates, 0)
        expect(result).to be(-1.0)
      end
    end

    context 'when all the amounts are zero' do
      let(:amounts) { [0, 0, 0] }
      let(:dates) { [Time.parse("1985-01-01").to_f, Time.parse("1990-01-01").to_f, Time.parse("1995-01-01").to_f] }
      it 'should return -1' do
        result = WiXirr.calculate(amounts, dates, 0)
        expect(result).to be(-1.0)
      end
    end

    context 'when the data set does not converge it returns -1' do
      let(:amounts) { [1000, -600, 500] }
      let(:dates) { [Time.parse("1985-01-01").to_f, Time.parse("1990-01-01").to_f, Time.parse("1995-01-01").to_f] }
      it 'should return -1' do
        result = WiXirr.calculate(amounts, dates, 0)
        expect(result).to be(-1.0)
      end
    end

    context 'when irr get a value of -1' do
      let(:amounts) { [1000, -600, -500] }
      let(:dates) { [Time.parse("1985-01-01").to_f, Time.parse("1990-01-01").to_f, Time.parse("1995-01-01").to_f] }
      it 'should return -1' do
        result = WiXirr.calculate(amounts, dates, -1)
        expect(result).to be(-1.0)
      end
    end

    context 'empty transactions and dates' do
      let(:amounts) { [] }
      let(:dates) { [] }
      it 'should return -1' do
        result = WiXirr.calculate(amounts, dates, -1)
        expect(result).to be(-1.0)
      end
    end
  end

  context 'to match excel' do
    context 'case 1' do
      let(:amounts) { [10000, -305.6, -500] }
      let(:dates) { [Time.parse("2014-04-15").to_f, Time.parse("2014-5-15").to_f, Time.parse("2014-10-19").to_f] }
      it 'should return XIRR matching with Excel' do
        result = WiXirr.calculate(amounts, dates, 0)
        expect(result).to be_within(0.00001).of(-0.99681)
      end
    end

    context 'case 2' do
      let(:amounts) { [900, -13.5] }
      let(:dates) { [Time.parse("2014-11-07").to_f, Time.parse("2015-05-06").to_f] }
      it 'should return XIRR matching with Excel' do
        result = WiXirr.calculate(amounts, dates, 0)
        expect(result).to be_within(0.00001).of(-0.99979)
      end
    end
  end

  context 'to handle non-converging input' do
    let(:amounts) { [-1293.6, 1990, -1590, 1990] }
    let(:dates) { [1549955890, 1547104687.0, 1547191087.0, 1549955888.0] }
    it 'should return -1 instead of going in a infinte loop' do
      result = WiXirr.calculate(amounts, dates, 0)
      expect(result).to eq(-1)
    end
  end

  context 'for benchmarking purpose' do
    xit 'returns xirr' do
      data = [
        [100000, Time.parse('2011-12-07').to_f],
        [2000, Time.parse('2011-12-07').to_f],
        [2000, Time.parse('2011-12-07').to_f],
        [2000, Time.parse('2012-01-18').to_f],
        [-10000, Time.parse('2012-07-03').to_f],
        [2000, Time.parse('2012-07-03').to_f],
        [2000, Time.parse('2012-07-19').to_f],
        [1000, Time.parse('2012-07-23').to_f],
        [2500, Time.parse('2012-07-23').to_f],
        [2500, Time.parse('2012-07-23').to_f],
        [-10000, Time.parse('2012-09-11').to_f],
        [-10000, Time.parse('2012-09-11').to_f],
        [-20000, Time.parse('2012-09-11').to_f],
        [10000, Time.parse('2012-09-11').to_f],
        [2000, Time.parse('2012-09-12').to_f],
        [2000, Time.parse('2012-09-12').to_f],
        [2000, Time.parse('2012-09-12').to_f],
        [2000, Time.parse('2012-09-12').to_f],
        [2000, Time.parse('2013-03-11').to_f],
        [2000, Time.parse('2013-03-11').to_f],
        [-10000, Time.parse('2013-03-11').to_f],
        [2000, Time.parse('2011-12-07').to_f],
        [2000, Time.parse('2011-12-07').to_f],
        [2000, Time.parse('2012-01-18').to_f],
        [-10000, Time.parse('2012-07-03').to_f],
        [2000, Time.parse('2012-07-03').to_f],
        [2000, Time.parse('2012-07-19').to_f],
        [1000, Time.parse('2012-07-23').to_f],
        [2500, Time.parse('2012-07-23').to_f],
        [2500, Time.parse('2012-07-23').to_f],
        [-10000, Time.parse('2012-09-11').to_f],
        [-10000, Time.parse('2012-09-11').to_f],
        [-20000, Time.parse('2012-09-11').to_f],
        [10000, Time.parse('2012-09-11').to_f],
        [2000, Time.parse('2012-09-12').to_f],
        [2000, Time.parse('2012-09-12').to_f],
        [2000, Time.parse('2012-09-12').to_f],
        [2000, Time.parse('2012-09-12').to_f],
        [2000, Time.parse('2013-03-11').to_f],
        [2000, Time.parse('2013-03-11').to_f],
        [-10000, Time.parse('2013-03-11').to_f],
        [2500, Time.parse('2013-03-11').to_f],
        [2500, Time.parse('2013-03-28').to_f],
        [-90000, Time.parse('2013-03-28').to_f]
      ]
      amounts = []
      dates = []
      data.each do | d |
        amounts << d[0]
        dates << d[1]
      end
      benches = Benchmark.measure { (1..100000).each { |i| WiXirr.calculate(amounts, dates, 0) }}
      expect(benches.total).to be_within(0.2).of(0.6)
    end
  end

end
