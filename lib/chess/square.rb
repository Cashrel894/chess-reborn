# frozen_string_literal: true

module Chess
  #
  # Represents a single square on a 8*8 Chess board.
  #
  class Square
    def self.from(obj)
      return obj if obj.is_a?(self)

      raise ArgumentError unless obj.match(/\A[a-h][1-8]\z/i)

      new(obj[1], obj[0])
    end

    attr_reader :rank, :file

    def to_s
      @file + @rank
    end

    private

    #
    # Rep invariant:
    #   @rank in '1'..'8', @file in 'a'..'h'
    #
    # Abstraction Function:
    #   AF(@rank, @file) = the square with rank @rank and file @file
    #
    # Safety from rep exposure:
    #   All fields are private;
    #   @rank and @file are both from indexing method and defensively frozen.
    #

    def initialize(rank, file)
      @rank = rank.freeze
      @file = file.freeze

      check_rep
    end

    def check_rep
      ('1'..'8').include?(@rank) && ('a'..'h').include?(@file)
    end
  end
end
