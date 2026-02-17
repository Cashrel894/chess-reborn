# frozen_string_literal: true

module Chess
  module Ruleset
    #
    # Provides logical operators for rule units.
    #
    module Logical
      def &(other)
        And.new(self, other)
      end

      def |(other)
        Or.new(self, other)
      end

      #
      # Represents an and-combination of two rules.
      #
      class And
        include Logical

        def initialize(rule1, rule2)
          @rule1 = rule1
          @rule2 = rule2
        end

        def eval(game, move)
          result1 = @rule1.eval(game, move)
          return result1 unless result1.ok?

          @rule2.eval(game, move)
        end
      end

      #
      # Represents an or-combination of two rules.
      #
      class Or
        include Logical

        def initialize(rule1, rule2)
          @rule1 = rule1
          @rule2 = rule2
        end

        def eval(game, move)
          result1 = @rule1.eval(game, move)
          return result1 if result1.ok?

          @rule2.eval(game, move)
        end
      end

      private_constant :And, :Or
    end
  end
end
