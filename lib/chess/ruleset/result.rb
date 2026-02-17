# frozen_string_literal: true

module Chess
  module Ruleset
    #
    # Represents the judgement result of the ruleset.
    #
    class Result
      def self.ok(game)
        new(true, game, OK_MSG)
      end

      def self.err(game, detail)
        new(false, game, detail)
      end

      def ok?
        @is_ok
      end

      attr_reader :game, :detail

      private

      #
      # Rep Invariant:
      #   @is_ok: Boolean, @game: Game, @detail: String
      #   When @is_ok, detail must be 'Legal move.';
      #   else, detail should be something else.
      # Abstraction Function:
      #   AF(@is_ok, @game, @detail) =
      #     A result evaled by the ruleset:
      #      If @is_ok, @game is the new game after the move is applied and @detail is the default ok msg.
      #      Else, @game is the original game and @detail is the details of the error.
      #

      OK_MSG = 'Legal move.'

      def initialize(is_ok, game, detail)
        @is_ok = is_ok
        @game = game
        @detail = detail
      end
    end
  end
end
