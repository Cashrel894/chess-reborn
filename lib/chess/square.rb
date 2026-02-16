# frozen_string_literal: true

module Chess
  #
  # Represents a single square on a 8*8 Chess board.
  #
  class Square
    def self.from(obj)
      return obj if obj.is_a? self

      raise ArgumentError unless obj.is_a?(String) && obj.length == 2

      create(obj[1], obj[0])
    end

    def rank
      rank_to_mark(rank_idx)
    end

    def file
      file_to_mark(file_idx)
    end

    attr_reader :rank_idx, :file_idx

    def idx
      [rank_idx, file_idx]
    end

    def to_s
      file + rank
    end

    def self.by_idx(rank_idx, file_idx)
      rank_idx = rank_idx.to_i
      file_idx = file_idx.to_i

      raise ArgumentError unless valid_idx?(rank_idx) && valid_idx?(file_idx)

      get_instance(rank_idx, file_idx)
    end

    class << self
      alias [] by_idx
    end

    def offset_by(rank_offs, file_offs)
      rank_offs = rank_offs.to_i
      file_offs = file_offs.to_i

      new_rank_idx = rank_idx + rank_offs
      new_file_idx = file_idx + file_offs

      return nil unless valid_idx?(new_rank_idx) && valid_idx?(new_file_idx)

      self.class.by_idx(new_rank_idx, new_file_idx)
    end

    private

    #
    # Rep invariant:
    #   @rank_idx and @file_idx are both integers and in [0, 7]
    #
    # Abstraction Function:
    #   AF(@rank_idx, @file_idx) = the square with double idx (@rank_idx, @file_idx)
    #
    # Safety from rep exposure:
    #   All fields are private;
    #   @rank_idx and @file_idx are both integers.
    #

    def initialize(rank_idx, file_idx)
      @rank_idx = rank_idx
      @file_idx = file_idx
    end

    #
    # Provides private helper methods for Square class.
    #
    module SquareHelpers
      private

      RANK_BASE = '1'
      FILE_BASE = 'a'

      # arg verifiers

      def valid_idx?(idx)
        idx.respond_to?(:between?) && idx.between?(0, 7)
      end

      def valid_mark?(mark, base_mark)
        mark.respond_to?(:ord) && valid_idx?(to_idx(mark, base_mark))
      end

      def valid_rank?(mark)
        valid_mark?(mark, RANK_BASE)
      end

      def valid_file?(mark)
        valid_mark?(mark, FILE_BASE)
      end
      # transformation methods between mark and idx

      def to_idx(mark, base_mark)
        mark.ord - base_mark.ord
      end

      def to_mark(idx, base_mark)
        (base_mark.ord + idx).chr
      end

      def rank_to_mark(idx)
        to_mark(idx, RANK_BASE)
      end

      def file_to_mark(idx)
        to_mark(idx, FILE_BASE)
      end

      def rank_to_idx(mark)
        to_idx(mark, RANK_BASE)
      end

      def file_to_idx(mark)
        to_idx(mark, FILE_BASE)
      end
    end

    include SquareHelpers

    class << self
      private

      include SquareHelpers

      def get_instance(rank_idx, file_idx)
        @instances ||= {}

        key = [rank_idx, file_idx].freeze
        return @instances[key] if @instances.include? key

        @instances[key] = new(rank_idx, file_idx)
      end

      def create(rank, file)
        file = file.downcase
        raise ArgumentError unless valid_rank?(rank) && valid_file?(file)

        by_idx(rank_to_idx(rank), file_to_idx(file))
      end
    end
  end
end
