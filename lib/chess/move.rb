# frozen_string_literal: true

module Chess
  #
  # Represents a move from one square to another on a Chess board.
  #
  class Move
    def self.from(obj)
      return obj if obj.is_a? self

      raise ArgumentError unless obj.is_a?(String) && valid_move_str?(obj)

      from = obj[0..1]
      to = obj[2..3]
      promotion = obj[4]

      new(from, to, promotion)
    end

    attr_reader :from, :to, :promotion

    # TODO: move the following pathing methods to rule modules about Rook, Bishop and Queen.

    def path
      raise ArgumentError unless aligned?(@from, @to)

      rank_idx_arr = to_idx_arr(@from.rank_idx, @to.rank_idx)
      file_idx_arr = to_idx_arr(@from.file_idx, @to.file_idx)

      path_arr(rank_idx_arr, file_idx_arr).uniq # The #uniq handles the single square case
    end

    def aligned?(from, to)
      horizonally_aligned?(from, to) ||
        vertically_aligned?(from, to) ||
        diagonally_aligned?(from, to)
    end

    def horizonally_aligned?(from, to)
      from.rank == to.rank
    end

    def vertically_aligned?(from, to)
      from.file == to.file
    end

    def diagonally_aligned?(from, to)
      forth_diagonally_aligned?(from, to) ||
        back_diagonally_aligned?(from, to)
    end

    private

    #
    # Rep Invariant:
    #   @from and @to and Square's.
    #   @promotion is a Symbol, which can only be :rook, :knight, :bishop, :queen or :no_promotion.
    # Abstraction Function:
    #   AF(@from, @to, @promotion) = a move from @from to @to on Chess board,
    #     with promotion specified as @promotion if @promotion is not :no_promotion
    #
    def initialize(from, to, promotion = nil)
      @from = Square.from(from)
      @to = Square.from(to)
      @promotion = promotion.nil? ? :no_promotion : Piece.from(promotion.to_sym).type
    end

    #
    # Provides private helper methods for Move class.
    #
    module MoveHelpers
      private

      # validator
      def valid_move_str?(str)
        str.match(/\A([a-h][1-8]){2}[qrnb]?\z/i)
      end

      # #path helpers
      def path_arr(rank_idx_arr, file_idx_arr)
        path_idx_arr(rank_idx_arr, file_idx_arr).map do |idx_pair|
          rank_idx = idx_pair[1]
          file_idx = idx_pair[2]
          Square.by_index(rank_idx, file_idx)
        end
      end

      def path_idx_arr(rank_idx_arr, file_idx_arr)
        arr = Array.new(8, 0).zip(rank_idx_arr, file_idx_arr)
        arr.reject do |idx_pair|
          idx_pair.include? nil
        end
      end

      def to_idx_arr(st_idx, ed_idx)
        return [st_idx] * 8 if st_idx == ed_idx # For rank of horizonal align & file of vertical align.

        return to_idx_arr(ed_idx, st_idx).reverse if st_idx > ed_idx

        (st_idx..ed_idx).to_a
      end

      # align verifiers

      def rank_offs(from, to)
        to.rank_idx - from.rank_idx
      end

      def file_offs(from, to)
        to.file_idx - from.file_idx
      end

      def forth_diagonally_aligned?(from, to)
        rank_offs(from, to) == file_offs(from, to)
      end

      def back_diagonally_aligned?(from, to)
        rank_offs(from, to) == -file_offs(from, to)
      end
    end

    include MoveHelpers

    class << self
      include MoveHelpers
    end
  end
end
