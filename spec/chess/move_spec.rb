# frozen_string_literal: true

RSpec.describe Chess::Move do
  shared_examples 'right move' do |from_str, to_str, promotion_type|
    it 'returns the right move' do
      is_expected.to be_a described_class
      expect(subject.from).to be_a Chess::Square
      expect(subject.from.to_s).to eq from_str

      expect(subject.to).to be_a Chess::Square
      expect(subject.to.to_s).to eq to_str

      expect(subject.promotion).to eq promotion_type
    end
  end

  describe '.from' do
    #
    # Testing Strategy:
    #   When obj is a Move object:
    #   When obj is a String:
    #     partition on promotion existence: true, false
    #     partition on file's case: downcase, upcase, mixed
    #     partition on promotion's case: downcase, upcase
    #     partition on invalidity: valid, from invalid, to invalid, promotion invalid
    #

    shared_examples 'raise error' do
      it 'raises ArgumentError' do
        expect { described_class.from(obj) }.to raise_error ArgumentError
      end
    end

    subject(:move) { described_class.from(obj) }

    context 'when obj is a Move object' do
      let(:obj) { described_class.from('f2f4') }

      it 'returns the same object' do
        is_expected.to be_a described_class
        is_expected.to be obj
      end
    end

    context 'when obj is a String' do
      context 'with no promotion & downcased files' do
        let(:obj) { 'a1h8' }

        include_examples 'right move', 'a1', 'h8', :no_promotion
      end

      context 'with downcased promotion & upcased files' do
        let(:obj) { 'E4G8n' }

        include_examples 'right move', 'e4', 'g8', :knight
      end

      context 'with upcased promotion & mix-cased files' do
        let(:obj) { 'D2b3B' }

        include_examples 'right move', 'd2', 'b3', :bishop
      end

      context 'with invalid string length' do
        let(:obj) { 'f7f8queen' }

        include_examples 'raise error'
      end

      context 'with invalid from' do
        let(:obj) { 'a9h5q' }

        include_examples 'raise error'
      end

      context 'with invalid to' do
        let(:obj) { 'C7I2R' }

        include_examples 'raise error'
      end

      context 'with invalid promotion' do
        let(:obj) { 'E6h4k' }

        include_examples 'raise error'
      end
    end
  end

  describe '#path' do
    #
    # Testing Strategy:
    #   partition on relationship between move and to:
    #     same square
    #     horizonally aligned,
    #     vertically aligned,
    #     diagonally aligned,
    #     none of above
    #
    shared_examples 'right path' do |path_squares_strs|
      it 'returns the right path' do
        is_expected.to be_a Array
        expect(subject.map(&:to_s)).to eq path_squares_strs
      end
    end

    shared_examples 'raise error' do
      it 'raises ArgumentError' do
        expect { move.path }.to raise_error ArgumentError
      end
    end

    let(:move) { described_class.from(move_str) }
    subject(:path) { move.path }

    context 'when from and to are the same square' do
      let(:move_str) { 'e4e4' }

      include_examples 'right path', %w[e4]
    end

    context 'when from and to are horizonally aligned' do
      let(:move_str) { 'b1g1' }

      include_examples 'right path', %w[b1 c1 d1 e1 f1 g1]
    end

    context 'when from and to are vertically aligned' do
      let(:move_str) { 'f6f3' }

      include_examples 'right path', %w[f6 f5 f4 f3]
    end

    context 'when from and to are diagonally aligned' do
      let(:move_str) { 'g3d6' }

      include_examples 'right path', %w[g3 f4 e5 d6]
    end

    context 'when from and to are not aligned' do
      let(:move_str) { 'h7g3' }

      include_examples 'raise error'
    end
  end
end
