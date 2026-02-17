# frozen_string_literal: true

require_relative 'logical'

module Chess
  module Ruleset
    #
    # Represent a minimal rule unit in the ruleset.
    #
    class Unit
      include Logical

      def initialize(&body)
        raise ArgumentError unless block_given?

        @body = body
      end

      def eval(game, move)
        UnitDSL.new(game).eval(game, move, &@body)
      end

      class UnitNoReturnValueError < StandardError; end

      #
      # Manages Unit's eval DSL.
      #
      class UnitDSL
        def initialize(original_game)
          @original_game = original_game
        end

        def ok(game)
          throw :ret, Result.ok(game)
        end

        def err(detail)
          throw :ret, Result.err(@original_game, detail)
        end

        def eval(game, move, &body)
          catch(:ret) do
            instance_exec(game, move, &body)
            raise UnitNoReturnValueError, 'Neither #ok nor #err is called.'
          end
        end
      end

      private_constant :UnitDSL
    end
  end
end
