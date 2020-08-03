# frozen_string_literal: true

class Deck
  attr_accessor :deck

  def initialize
    @deck = []
    @suits = %w[Red Green Blue Yellow]
    @ranks = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 'Skip', 'Reverse', 'Draw2']
    populate
  end

  def populate
    @suits.each do |suit|
      @ranks.each do |rank|
        if rank != 0
          count = 0
          while count <= 1
            @deck << Card.new(suit, rank)
            count += 1
          end
        else
          @deck << Card.new(suit, rank)
        end
      end
    end

    until @deck.length == 108
      @deck << Card.new('none', 'Wild')
      @deck << Card.new('none', 'Wild+4')
    end

    @deck.shuffle!
  end

  def output_card
    selected_card = @deck[0]
    @deck.delete_at(0)
    selected_card
  end
end
