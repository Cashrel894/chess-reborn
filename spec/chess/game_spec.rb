# frozen_string_literal: true

RSpec.describe Chess::Game do
  shared_examples 'right game' do |msg = 'returns the right game'|
    it msg do
      is_expected.to be_a described_class
      expect(subject.board).to eq(Chess::Board.from(board)) if board
      expect(subject.current_player).to eq(current_player) if current_player
      expect(subject.turn_id).to eq(turn_id) if turn_id
      expect(subject.status).to eq(status) if status
    end
  end

  describe '.default' do
    let(:board) do
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
    let(:current_player) { :white }
    let(:turn_id) { 0 }
    let(:status) { :in_progress }

    subject(:game) { described_class.default }

    include_examples 'right game'
  end

  describe '.custom' do
    #
    # Testing Strategy:
    #   partition on board: valid, invalid
    #   partition on current_player: valid, invalid
    #   partition on turn_id: valid, invalid
    #

    shared_examples 'raise error' do
      it 'raises ArgumentError' do
        expect { described_class.custom(board: board, current_player: current_player, turn_id: turn_id) }
          .to raise_error ArgumentError
      end
    end

    subject(:game) { described_class.custom(board: board, current_player: current_player, turn_id: turn_id) }

    context 'when all args are valid' do
      let(:board) do
        %i[
          _ _ _ _ _ _ _ _
          _ _ _ _ _ _ _ _
          _ p _ p _ _ _ _
          _ _ _ _ _ _ _ P
          _ _ _ _ _ P _ K
          _ _ _ _ _ _ P p
          R _ _ _ _ _ p _
          _ _ _ _ _ r _ k
        ]
      end
      let(:current_player) { :white }
      let(:turn_id) { 0 }
      let(:status) { :in_progress }

      include_examples 'right game'
    end

    context 'when board is invalid' do
      let(:board) do
        %i[
          _ _ _ _ _ _ _ _
          _ _ _ _ _ _ _ _
          _ p _ p _ _ _ _
          _ _ _ _ _ _ _ P
          _ _ _ _ _ P _ K
          _ _ _ _ _ _ P p
          R _ _ _ _ _ p _
          _ _ _ _ _ r _ k
          _ _ _ _ _ _ _ _
        ] # 9 * 8 board
      end
      let(:current_player) { :black }
      let(:turn_id) { 5 }
      let(:status) { :in_progress }

      include_examples 'raise error'
    end

    context 'when current_player is invalid' do
      let(:board) do
        %i[
          _ _ _ _ _ _ _ _
          _ _ _ _ _ _ _ _
          _ p _ p _ _ _ _
          _ _ _ _ _ _ _ P
          _ _ _ _ _ P _ K
          _ _ _ _ _ _ P p
          R _ _ _ _ _ p _
          _ _ _ _ _ r _ k
        ]
      end
      let(:current_player) { :red }
      let(:turn_id) { 114_514 }
      let(:status) { :in_progress }

      include_examples 'raise error'
    end

    context 'when turn_id is invalid' do
      let(:board) do
        %i[
          _ _ _ _ _ _ _ _
          _ _ _ _ _ _ _ _
          _ p _ p _ _ _ _
          _ _ _ _ _ _ _ P
          _ _ _ _ _ P _ K
          _ _ _ _ _ _ P p
          R _ _ _ _ _ p _
          _ _ _ _ _ r _ k
        ]
      end
      let(:current_player) { :white }
      let(:turn_id) { -1 }
      let(:status) { :in_progress }

      include_examples 'raise error'
    end
  end
end
