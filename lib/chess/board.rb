# frozen_string_literal: true

module Chess
  #
  # Represents the board in Chess game.
  #
  class Board
    include Enumerable

    def self.empty
      new
    end

    def self.default
      custom(DEFAULT_SYM_ARR)
    end

    def self.custom(sym_arr)
      raise ArgumentError unless sym_arr.is_a?(Array) && sym_arr.length == 8 * 8

      pieces = {}
      sym_arr.each_with_index do |sym, idx|
        square = Square.by_index(idx / 8, idx % 8)
        piece = Piece.from(sym)
        pieces[square] = piece
      end

      new(pieces)
    end

    def set(square, piece)
      square = Square.from(square)
      piece = Piece.from(piece)

      new_pieces = @pieces.clone
      new_pieces[square] = piece
      self.class.new(new_pieces)
    end

    def reset(square)
      set(square, :_)
    end

    def get(square)
      square = Square.from(square)

      @pieces[square]
    end

    alias [] get

    def each
      single_index = (0..7).to_a
      double_index = single_index.product(single_index)

      double_index.map do |square_index|
        square = Square.by_index(*square_index)
        yield get(square)
      end
    end

    def ==(other)
      to_a == other.to_a
    end

    private

    #
    # Rep Invariant:
    #   @pieces is a hash whose every key-value pairs (square, piece) satisfies that:
    #     square is a Square and piece is a Piece.
    # Abstraction Function:
    #   AF(@pieces) = a board that for every key-value pair (square, piece), there's piece in square.
    #     For a square not in @pieces' keys, there's an empty piece.
    #

    DEFAULT_SYM_ARR = %i[
      R N B Q K B N R
      P P P P P P P P
      _ _ _ _ _ _ _ _
      _ _ _ _ _ _ _ _
      _ _ _ _ _ _ _ _
      _ _ _ _ _ _ _ _
      p p p p p p p p
      r n b q k b n r
    ].freeze

    def initialize(pieces = nil)
      @pieces = pieces || Hash.new(Piece.empty)
    end
  end
end
