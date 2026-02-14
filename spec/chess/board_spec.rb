# frozen_string_literal: true

RSpec.describe Chess::Board do
  shared_examples 'right board' do |square, piece|
    it 'returns the right board' do
      is_expected.to be_a described_class
      expect(subject.get(square)).to eq(piece)
    end
  end

  describe '.empty' do
    subject(:board) { described_class.empty }

    it 'returns an empty board' do
      is_expected.to all be_empty
    end
  end

  describe '#get & #set' do
    #
    # Testing Strategy:
    #   partition on square: Square object, others
    #   partition on piece: Piece object, others
    #

    let(:board) { described_class.empty }
    subject(:new_board) { board.set(square, piece) }

    context 'with square a Square & piece a Piece' do
      let(:square) { Chess::Square.from('f3') }
      let(:piece) { Chess::Piece.from(:P) }

      include_examples 'right board', 'f3', Chess::Piece.from(:P)
    end

    context 'with square a String & piece a Symbol' do
      let(:square) { 'f3' }
      let(:piece) { :P }

      include_examples 'right board', 'f3', Chess::Piece.from(:P)
    end
  end

  describe '#reset' do
    let(:board) { described_class.empty.set('f5', :p) }

    context 'with square a Square' do
      let(:square) { Square.from('f5') }

      include_examples 'right board', 'f5', Chess::Piece.empty
    end

    context 'with square a String' do
      let(:square) { 'f5' }

      include_examples 'right board', 'f5', Chess::Piece.empty
    end
  end

  describe '#custom' do
    let(:sym_arr) do
      %i[
        R N B Q K B N R
        P P P P P P P P
        _ _ _ _ _ _ _ _
        _ _ _ _ _ _ _ _
        _ _ _ _ _ _ _ _
        _ _ _ _ _ _ _ _
        p p p p p p p p
        r n b q k b n r
      ]
    end
    subject(:board) { described_class.custom(sym_arr) }

    include_examples 'right board', 'e1', Chess::Piece.from(:K)
    include_examples 'right board', 'b2', Chess::Piece.from(:P)
    include_examples 'right board', 'c4', Chess::Piece.from(:_)
    include_examples 'right board', 'h7', Chess::Piece.from(:p)
    include_examples 'right board', 'f8', Chess::Piece.from(:b)
  end

  describe '#each' do
    subject(:board) { described_class.default }

    let(:black_pawn) { Chess::Piece.from(:p) }
    it 'works well with #count' do
      expect(board.count(black_pawn)).to eq(8)
    end

    let(:white_pieces) { board.filter { |p| p.player == :white } }
    it 'works well with #filter' do
      expect(white_pieces.length).to eq(16)
    end
  end
end
