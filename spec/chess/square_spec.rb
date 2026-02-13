# frozen_string_literal: true

require_relative '../../lib/chess/square'

RSpec.describe Chess::Square do
  describe '#rank & #file & #to_s' do
    subject(:square) { described_class.from('e4') }

    it 'returns a String object represeting the rank, file or square' do
      expect(square.rank).to eq('4')
      expect(square.file).to eq('e')
      expect(square.to_s).to eq('e4')
    end
  end

  describe '.from' do
    #
    # Testing Strategy:
    #   Partition on obj's type:
    #     When obj is a Square
    #     When obj is a String:
    #       Partition on file's case: lower, upper
    #       Partition on rank: ='1', ='8', in '2'..'7'
    #       Partition on file: ='a', ='h', in 'b'..'g'
    #

    context 'when obj is a Square' do
      let(:obj) { described_class.from('b5') }
      subject(:square) { described_class.from(obj) }

      it { is_expected.to be_a described_class }
      it 'returns the same object' do
        is_expected.to be(obj)
      end
    end

    context 'when obj is a String' do
      context "with lowercase file & file = 'a' & rank = '1'" do
        subject(:square) { described_class.from('a1') }

        it 'returns a Square object' do
          is_expected.to be_a described_class
        end
      end

      context "with uppercase file & file = 'h' & rank = '8'" do
        subject(:square) { described_class.from('H8') }

        it 'returns a Square object' do
          is_expected.to be_a described_class
        end
      end

      context "with file in 'b'..'g' & rank = '2'..'7'" do
        subject(:square) { described_class.from('e4') }

        it 'returns a Square object' do
          is_expected.to be_a described_class
        end
      end

      context 'with invalid input' do
        it 'raises ArgumentError' do
          expect { described_class.from('i5') }.to raise_error ArgumentError
        end
      end
    end
  end
end
