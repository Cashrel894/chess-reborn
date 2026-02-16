# frozen_string_literal: true

RSpec.describe Chess::Square do
  shared_examples 'right square' do |rank, file|
    it 'returns the right square' do
      is_expected.to be_a described_class
      expect(subject.rank).to eq(rank)
      expect(subject.file).to eq(file)
    end
  end

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

    subject(:square) { described_class.from(obj) }

    context 'when obj is a Square' do
      let(:obj) { described_class.from('b5') }

      it 'returns the same object' do
        is_expected.to be obj
      end
    end

    context 'when obj is a String' do
      context "with lowercase file & file = 'a' & rank = '1'" do
        let(:obj) { 'a1' }

        include_examples 'right square', '1', 'a'
      end

      context "with uppercase file & file = 'h' & rank = '8'" do
        let(:obj) { 'H8' }

        include_examples 'right square', '8', 'h'
      end

      context "with file in 'b'..'g' & rank = '2'..'7'" do
        let(:obj) { 'e4' }

        include_examples 'right square', '4', 'e'
      end

      context 'with invalid input' do
        let(:obj) { 'i5' }
        it 'raises ArgumentError' do
          expect { described_class.from('i5') }.to raise_error ArgumentError
        end
      end
    end
  end

  describe '.by_idx' do
    #
    # Testing Strategy:
    #   When rank and file are both integers:
    #     partition on rank: 0, 1-6, 7, invalid
    #     partition on file: 0, 1-6, 7, invalid
    #   When rank and file are either non-integer objects that respond to #to_i
    #

    subject(:square) { described_class.by_idx(rank_idx, file_idx) }

    context 'when rank_idx and file_idx are both integers' do
      context 'with rank_idx = 0 & file_idx = 0' do
        let(:rank_idx) { 0 }
        let(:file_idx) { 0 }

        include_examples 'right square', '1', 'a'
      end

      context 'with rank_idx = 7 & file_idx = 7' do
        let(:rank_idx) { 7 }
        let(:file_idx) { 7 }

        include_examples 'right square', '8', 'h'
      end

      context 'with rank_idx in [2, 6] & file_idx in [2, 6]' do
        let(:rank_idx) { 3 }
        let(:file_idx) { 5 }

        include_examples 'right square', '4', 'f'
      end

      context 'with either rank_idx or file_idx out of range' do
        let(:rank_idx) { 9 }
        let(:file_idx) { 3 }

        it 'raises ArgumentError' do
          expect { described_class.by_idx(rank_idx, file_idx) }.to raise_error ArgumentError
        end
      end
    end

    context 'when either rank_idx or file_idx is object that responds to #to_i' do
      let(:rank_idx) { '3' }
      let(:file_idx) { '5' }

      include_examples 'right square', '4', 'f'
    end
  end

  describe '#offset_by' do
    #
    # Testing Strategy:
    #   When rank_offs and file_offs are both integers:
    #     partition on rank_offs: <0, =0, >0
    #     partition on file_offs: <0, =0, >0
    #     partition on result legality: true, false
    #   When either rank_offs or file_offs is object that responds to #to_i
    #

    let(:square) { described_class.from('d4') }
    subject(:offs) { square.offset_by(rank_offs, file_offs) }

    context 'when rank_offs and file_offs are both integers' do
      context 'with rank_offs < 0 & file_offs > 0 & result is legal' do
        let(:rank_offs) { -3 }
        let(:file_offs) { 2 }

        include_examples 'right square', '1', 'f'
      end

      context 'with rank_offs > 0 & file_offs = 0 & result is legal' do
        let(:rank_offs) { 2 }
        let(:file_offs) { 0 }

        include_examples 'right square', '6', 'd'
      end

      context 'with rank_offs = 0 & file_offs < 0 & result is legal' do
        let(:rank_offs) { 0 }
        let(:file_offs) { -1 }

        include_examples 'right square', '4', 'c'
      end

      context 'with illegal result' do
        let(:rank_offs) { 5 }
        let(:file_offs) { 2 }

        it 'returns nil' do
          is_expected.to be_nil
        end
      end
    end

    context 'when either rank_offs or file_offs is object that responds to #to_i' do
      let(:rank_offs) { '0' }
      let(:file_offs) { '-1' }

      include_examples 'right square', '4', 'c'
    end
  end
end
