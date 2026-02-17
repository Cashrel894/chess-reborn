# frozen_string_literal: true

RSpec.describe Chess::Ruleset::Unit do
  describe '.new' do
    context 'when given a block' do
      subject(:to_file_h) do
        described_class.new do |game, move|
          ok(game) if move.to.file == 'h'
          err('The move is not to file h.')
        end
      end

      it 'returns a Unit' do
        is_expected.to be_a described_class
      end
    end

    context 'when not given a block' do
      it 'raises ArgumentError' do
        expect { described_class.new }.to raise_error ArgumentError
      end
    end
  end

  describe '#eval' do
    let(:unit) do
      described_class.new do |game, move|
        ok(game) if move.to.rank == '5'
        err('The move is not to rank 5.')
      end
    end

    let(:game) { Chess::Game.default }
    subject(:result) { unit.eval(game, move) }

    context 'when the move is ok' do
      let(:move) { Chess::Move.from('e1e5') }

      it 'returns an ok result' do
        expect(result).to be_a Chess::Ruleset::Result
        expect(result).to be_ok
      end
    end

    context 'when the move is not ok' do
      let(:move) { Chess::Move.from('a1a2') }

      it 'returns a not ok result' do
        expect(result).to be_a Chess::Ruleset::Result
        expect(result).not_to be_ok
      end
    end

    context 'when neither #ok nor #err is called' do
      let(:unit) do
        described_class.new do |game, move|
          ok(game) if move.to.rank == '5'
          err('The move is not to rank 5.') if move.to.rank == '5'
        end
      end

      let(:move) { Chess::Move.from('a1a2') }

      it 'raises an error' do
        expect { unit.eval(game, move) }.to raise_error described_class::UnitNoReturnValueError
      end
    end
  end
end
