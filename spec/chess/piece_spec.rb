require_relative '../../lib/chess/piece'

RSpec.describe Chess::Piece do
  shared_examples 'right piece' do |type, player|
    it 'returns the right Piece' do
      is_expected.to be_a described_class
      expect(subject.type).to eq(type)
      expect(subject.player).to eq(player)
    end
  end

  describe '.create' do
    subject(:piece) { described_class.create(type, player) }

    context 'when given valid type and player' do
      let(:type) { :pawn }
      let(:player) { :white }

      include_examples 'right piece', :pawn, :white
    end

    context 'when given invalid type or player' do
      shared_examples 'raise error' do
        it 'raises ArgumentError' do
          expect { described_class.create(type, player) }.to raise_error ArgumentError
        end
      end

      context 'when given invalid type' do
        let(:type) { :QuEen }
        let(:player) { :black }

        include_examples 'raise error'
      end

      context 'when given invalid player' do
        let(:type) { :queen }
        let(:player) { :red }

        include_examples 'raise error'
      end
    end
  end

  describe '#empty' do
    subject(:piece) { described_class.empty }

    it 'returns an empty piece' do
      expect(piece.type).to eq(:empty)
      expect(piece.player).to eq(:no_player)
    end
  end

  describe '#player' do
    let(:piece) { described_class.create(:rook, :white) }
    subject(:player) { piece.player }

    it { is_expected.to be_a Symbol }
  end

  describe '#type' do
    let(:piece) { described_class.create(:knight, :black) }
    subject(:type) { piece.type }

    it { is_expected.to be_a Symbol }
  end

  describe '.from' do
    #
    # Testing Strategy:
    #   Partition on obj's type:
    #     When obj is a Piece
    #     When obj is a Symbol:
    #       Partition on obj's player: white, black
    #       Partition on obj's type: pawn, rook, knight, bishop, queen, king
    #

    subject(:piece) { described_class.from(obj) }

    context 'when obj is a Piece' do
      let(:obj) { described_class.create(:pawn, :white) }

      it { is_expected.to be_a described_class }
      it 'returns the same object' do
        is_expected.to be obj
      end
    end

    context 'when obj is a Symbol' do
      context 'with type of Pawn & player of White' do
        let(:obj) { :P }

        include_examples 'right piece', :pawn, :white
      end

      context 'with type of Rook & player of Black' do
        let(:obj) { :r }

        include_examples 'right piece', :rook, :black
      end

      context 'with type of Knight & player of White' do
        let(:obj) { :N }

        include_examples 'right piece', :knight, :white
      end

      context 'with type of Bishop & player of Black' do
        let(:obj) { :b }

        include_examples 'right piece', :bishop, :black
      end

      context 'with type of Queen & player of White' do
        let(:obj) { :Q }

        include_examples 'right piece', :queen, :white
      end

      context 'with type of King & player of Black' do
        let(:obj) { :k }

        include_examples 'right piece', :king, :black
      end

      context 'with type of empty' do
        let(:obj) { :_ }

        include_examples 'right piece', :empty, :no_player
      end
    end
  end

  describe 'to_sym' do
    shared_examples 'right symbol' do |sym|
      it 'returns the right Symbol' do
        is_expected.to eq sym
      end
    end

    let(:piece) { described_class.create(type, player) }
    subject(:sym) { piece.to_sym }

    context 'with type of Pawn & player of Black' do
      let(:type) { :pawn }
      let(:player) { :black }

      include_examples 'right symbol', :p
    end

    context 'with type of Rook & player of White' do
      let(:type) { :rook }
      let(:player) { :white }

      include_examples 'right symbol', :R
    end

    context 'with type of Knight & player of Black' do
      let(:type) { :knight }
      let(:player) { :black }

      include_examples 'right symbol', :n
    end

    context 'with type of Bishop & player of White' do
      let(:type) { :bishop }
      let(:player) { :white }

      include_examples 'right symbol', :B
    end

    context 'with type of Queen & player of Black' do
      let(:type) { :queen }
      let(:player) { :black }

      include_examples 'right symbol', :q
    end

    context 'with type of King & player of White' do
      let(:type) { :king }
      let(:player) { :white }

      include_examples 'right symbol', :K
    end

    context 'with type of empty' do
      let(:piece) { described_class.empty }

      include_examples 'right symbol', :_
    end
  end
end
