# frozen_string_literal: true

module Chess
  #
  # The core of the Chess module, which manages all game states and information exchange with clients.
  #
  class Game
    def self.default
      custom
    end

    attr_reader :board, :current_player, :turn_id

    def status
      :in_progress
    end

    DEFAULT_LAYOUT = %i[
      R N B Q K B N R
      P P P P P P P P
      _ _ _ _ _ _ _ _
      _ _ _ _ _ _ _ _
      _ _ _ _ _ _ _ _
      _ _ _ _ _ _ _ _
      p p p p p p p p
      r n b q k b n r
    ].freeze

    def self.custom(board: DEFAULT_LAYOUT, current_player: :white, turn_id: 0)
      raise ArgumentError unless %i[white black].include? current_player

      raise ArgumentError unless turn_id.is_a?(Integer) && turn_id >= 0

      new(board, current_player, turn_id)
    end

    private

    def initialize(board, current_player, turn_id)
      @board = Board.from(board)
      @current_player = current_player
      @turn_id = turn_id
    end
  end
end
