# frozen_string_literal: true

module Chess
  module Ruleset
    #
    # Represents the judgement result of the ruleset.
    #
    class Result
      def self.ok(game); end

      def self.err(game, detail); end

      def ok?; end

      def game; end

      def detail; end
    end
  end
end
