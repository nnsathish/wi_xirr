require 'spec_helper'

describe Xirr do
  context 'for a realistic, good investment' do
    let(:amounts) { [1000, -600, -6000] }
    let(:dates) { [Time.parse("1985-01-01").to_f, Time.parse("1990-01-01").to_f, Time.parse("1995-01-01").to_f] }
    it 'should calculate the XIRR' do
      result = Xirr.calculate(amounts, dates, 0)
      expect(result).to be_within(0.00001).of(0.225683)
    end
  end

  context 'for a realistic, bad investment' do
    let(:amounts) { [1000, -600, -200] }
    let(:dates) { [Time.parse("1985-01-01").to_f, Time.parse("1990-01-01").to_f, Time.parse("1995-01-01").to_f] }
    it 'should calculate the XIRR' do
      result = Xirr.calculate(amounts, dates, 0)
      expect(result).to be_within(0.00001).of(-0.0346)
    end
  end

  context 'where sorting of transactions by date is not necessary' do
    let(:amounts) { [-200, -600, 1000] }
    let(:dates) { [Time.parse("1995-01-01").to_f, Time.parse("1990-01-01").to_f, Time.parse("1985-01-01").to_f] }
    it 'should calculate the XIRR' do
      result = Xirr.calculate(amounts, dates, 0)
      expect(result).to be_within(0.00001).of(-0.0346)
    end
  end

  context 'for all failure scenarios' do
    context 'for all negative amounts' do
      let(:amounts) { [-1000, -600, -6000] }
      let(:dates) { [Time.parse("1985-01-01").to_f, Time.parse("1990-01-01").to_f, Time.parse("1995-01-01").to_f] }
      it 'should return -1' do
        result = Xirr.calculate(amounts, dates, 0)
        expect(result).to be(-1.0)
      end
    end

    context 'for all positive amounts' do
      let(:amounts) { [1000, 600, 6000] }
      let(:dates) { [Time.parse("1985-01-01").to_f, Time.parse("1990-01-01").to_f, Time.parse("1995-01-01").to_f] }
      it 'should return -1' do
        result = Xirr.calculate(amounts, dates, 0)
        expect(result).to be(-1.0)
      end
    end

    context 'when all the dates are the same' do
      let(:amounts) { [1000, -600, -600] }
      let(:dates) { [Time.parse("2020-01-01").to_f, Time.parse("2020-01-01").to_f, Time.parse("2020-01-01").to_f] }
      it 'should return -1' do
        result = Xirr.calculate(amounts, dates, 0)
        expect(result).to be(-1.0)
      end
    end

    context 'when all the amounts are zero' do
      let(:amounts) { [0, 0, 0] }
      let(:dates) { [Time.parse("1985-01-01").to_f, Time.parse("1990-01-01").to_f, Time.parse("1995-01-01").to_f] }
      it 'should return -1' do
        result = Xirr.calculate(amounts, dates, 0)
        expect(result).to be(-1.0)
      end
    end

    context 'when the data set does not converge it returns -1' do
      let(:amounts) { [1000, -600, 500] }
      let(:dates) { [Time.parse("1985-01-01").to_f, Time.parse("1990-01-01").to_f, Time.parse("1995-01-01").to_f] }
      it 'should return -1' do
        result = Xirr.calculate(amounts, dates, 0)
        expect(result).to be(-1.0)
      end
    end

    context 'when irr get a value of -1' do
      let(:amounts) { [1000, -600, -500] }
      let(:dates) { [Time.parse("1985-01-01").to_f, Time.parse("1990-01-01").to_f, Time.parse("1995-01-01").to_f] }
      it 'should return -1' do
        result = Xirr.calculate(amounts, dates, -1)
        expect(result).to be(-1.0)
      end
    end

    context 'empty transactions and dates' do
      let(:amounts) { [] }
      let(:dates) { [] }
      it 'should return -1' do
        result = Xirr.calculate(amounts, dates, -1)
        expect(result).to be(-1.0)
      end
    end
  end

  context 'to match excel' do
    context 'case 1' do
      let(:amounts) { [10000, -305.6, -500] }
      let(:dates) { [Time.parse("2014-04-15").to_f, Time.parse("2014-5-15").to_f, Time.parse("2014-10-19").to_f] }
      it 'should return XIRR matching with Excel' do
        result = Xirr.calculate(amounts, dates, 0)
        expect(result).to be_within(0.00001).of(-0.99681)
      end
    end

    context 'case 2' do
      let(:amounts) { [900, -13.5] }
      let(:dates) { [Time.parse("2014-11-07").to_f, Time.parse("2015-05-06").to_f] }
      it 'should return XIRR matching with Excel' do
        result = Xirr.calculate(amounts, dates, 0)
        expect(result).to be_within(0.00001).of(-0.99979)
      end
    end
  end

end
