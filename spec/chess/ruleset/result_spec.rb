# frozen_string_literal: true

RSpec.describe Chess::Ruleset::Result do
  describe '.ok' do
    let(:game) { Chess::Game.default }
    subject(:result) { described_class.ok(game) }

    it 'returns an ok result' do
      is_expected.to be_a described_class
      is_expected.to be_ok
      expect(result.game).to be game
      expect(result.detail).to eq 'Legal move.'
    end
  end

  describe '.err' do
    let(:game) { Chess::Game.default }
    let(:detail) { 'Not a Pawn' }
    subject(:result) { described_class.err(game, detail) }

    it 'returns a not ok result' do
      is_expected.to be_a described_class
      is_expected.not_to be_ok
      expect(result.game).to be game
      expect(result.detail).to eq detail
    end
  end
end
