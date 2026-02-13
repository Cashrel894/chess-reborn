# frozen_string_literal: true

module Chess
  #
  # Represents a single piece in Chess game.
  #
  class Piece
    def self.create(type, player)
      raise ArgumentError unless nonempty_type?(type) && player?(player)

      new(type, player, false)
    end

    def self.empty
      new(nil, nil, true)
    end

    def empty?
      @is_empty
    end

    def self.from(obj)
      return obj if obj.is_a?(self)

      raise ArgumentError unless obj.is_a? Symbol

      return empty if obj == :_

      type = SYM_TO_NONEMPTY_TYPE[obj.downcase]
      player = CASE_TO_PLAYER[obj == obj.upcase]
      create(type, player)
    end

    def to_sym
      return :_ if empty?

      type_sym = NONEMPTY_TYPE_TO_SYM[@type]
      type_sym = type_sym.upcase if PLAYER_TO_CASE[@player]
      type_sym
    end

    attr_reader :type, :player

    private

    #
    # Rep Invariant:
    #   @type and @player are both Symbols.
    #   @type must be in TYPE_TO_SYM.keys, while @player must be in (PLAYER_TO_CASE.keys + [:no_player])
    #   When @type is in NO_PLAYER_TYPES, @player is :no_player, and vice_versa.
    # Abstraction Function:
    #   AF(@type, @player) = a Chess piece with type @type and player @player.
    # Safety from rep exposure:
    #   @type and @player are both private and immutable.
    #

    NONEMPTY_TYPE_TO_SYM = {
      pawn: :p,
      rook: :r,
      knight: :n,
      bishop: :b,
      queen: :q,
      king: :k
    }.freeze
    NONEMPTY_TYPES = NONEMPTY_TYPE_TO_SYM.keys.freeze
    SYM_TO_NONEMPTY_TYPE = NONEMPTY_TYPE_TO_SYM.invert.freeze

    PLAYER_TO_CASE = {
      white: true,
      black: false
    }.freeze
    PLAYERS = PLAYER_TO_CASE.keys.freeze
    CASE_TO_PLAYER = PLAYER_TO_CASE.invert.freeze

    def initialize(type, player, is_empty)
      @is_empty = is_empty
      @type = is_empty ? :empty : type
      @player = is_empty ? :no_player : player
    end

    def self.nonempty_type?(type)
      NONEMPTY_TYPES.include?(type)
    end

    def self.player?(player)
      PLAYERS.include?(player)
    end

    private_class_method :nonempty_type?, :player?
  end
end
