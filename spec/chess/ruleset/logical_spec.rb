# frozen_string_literal: true

RSpec.describe Chess::Ruleset::Logical do
  let(:game) { Chess::Game.default }

  let(:unit1) do
    Chess::Ruleset::Unit.new do |game, move|
      ok(game) if move.to.rank == '5'
      err('The move is not to rank 5.')
    end
  end
  let(:result1) { unit1.eval(game, move) }

  let(:unit2) do
    Chess::Ruleset::Unit.new do |game, move|
      ok(game) if move.to.file == 'e'
      err('The move is not to file e.')
    end
  end
  let(:result2) { unit2.eval(game, move) }

  let(:unit3) do
    Chess::Ruleset::Unit.new do |game, move|
      ok(game) if game.board[move.from].type == :rook
      err('The piece is not Rook.')
    end
  end
  let(:result3) { unit3.eval(game, move) }

  subject(:result) { rule.eval(game, move) }

  describe '#&' do
    context 'when given just two units' do
      let(:rule) { unit1 & unit2 }

      context 'when the first result is ok' do
        let(:move) { 'h1e5' }

        it 'returns the second result' do
          is_expected.to eq(result2)
        end
      end

      context 'when the first result is not ok' do
        let(:move) { 'h1e1' }

        it 'returns the first result' do
          is_expected.to eq(result1)
        end
      end
    end

    context 'when given more than two units' do
      let(:rule) { unit1 & unit2 & unit3 }

      context 'when the first result is not ok' do
        let(:move) { 'h1e1' }

        it 'returns the first result' do
          is_expected.to eq(result1)
        end
      end

      context 'when the first result is ok & the second is not' do
        let(:move) { 'h1h5' }

        it 'returns the second result' do
          is_expected.to eq(result2)
        end
      end

      context 'when the first two results are ok' do
        let(:move) { 'h1e5' }

        it 'returns the third result' do
          is_expected.to eq(result3)
        end
      end
    end
  end

  describe '#|' do
    context 'when given just two units' do
      let(:rule) { unit1 | unit2 }

      context 'when the first result is ok' do
        let(:move) { 'h1e5' }

        it 'returns the first result' do
          is_expected.to eq(result1)
        end
      end

      context 'when the first result is not ok' do
        let(:move) { 'h1e1' }

        it 'returns the second result' do
          is_expected.to eq(result2)
        end
      end
    end

    context 'when given more than two units' do
      let(:rule) { unit1 | unit2 | unit3 }

      context 'when the first result is ok' do
        let(:move) { 'h1h5' }

        it 'returns the first result' do
          is_expected.to eq(result1)
        end
      end

      context 'when the first result is not ok & the second is ok' do
        let(:move) { 'h1e1' }

        it 'returns the second result' do
          is_expected.to eq(result2)
        end
      end

      context 'when the first two results are not ok' do
        let(:move) { 'h1h2' }

        it 'returns the third result' do
          is_expected.to eq(result3)
        end
      end
    end
  end
end
