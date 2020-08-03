# frozen_string_literal: true

class Card
  attr_accessor :suit
  attr_accessor :rank
  attr_accessor :used

  def initialize(suit, rank)
    @suit = suit
    @rank = rank
    @used = false # for special cards
  end
end
