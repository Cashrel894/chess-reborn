# frozen_string_literal: true

require_relative 'logical'

module Chess
  module Ruleset
    #
    # Represent a minimal rule unit in the ruleset.
    #
    class Unit
      include Logical

      def self.new(&body); end

      def eval(game, move); end
    end
  end
end
