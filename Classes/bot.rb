# frozen_string_literal: true

require_relative '../Modules/methods.rb'
require_relative 'player.rb'

class Bot < Player
  include Methods

  attr_accessor :name
  attr_accessor :hand

  def initialize(name)
    @name = name
    @hand = []
  end

  # card color for wild cards based off of hand
  def determine_color
    colors = {'Red' => 0, 'Green' => 0, 'Yellow' => 0, 'Blue' => 0}
    @hand.each do |card|
      colors[card.suit] += 1
    end
    return colors.key(colors.values.max)
  end

  def play_card(discard_pile)
    @hand.each do |card|
      select_card = nil
      if card.suit == discard_pile.last.suit or card.rank == discard_pile.last.rank
        selected_card = card
        @hand.delete_at(@hand.index(card))
        return selected_card
      elsif card.suit == 'none'
        selected_card = card
        @hand.delete_at(@hand.index(card))
        return selected_card
      end
    end
  end

  def take_turn(discard_pile, cards)
    puts "Current card: #{discard_pile.last.suit} #{discard_pile.last.rank}"
    draw = verify_hand(discard_pile, @hand)
    if draw != true
      played_card = play_card(discard_pile)
      played_card.suit = determine_color if played_card.suit == 'none'
      puts "#{@name} played a #{played_card.suit} #{played_card.rank}"
      discard_pile << played_card
    else
      draw_card(cards)
      draw = verify_hand(discard_pile, @hand)
      if draw != true
        played_card = play_card(discard_pile)
        played_card.suit = determine_color if played_card.suit == 'none'
        puts "#{@name} played a #{played_card.suit} #{played_card.rank}"
        discard_pile << played_card
      else
        puts "#{@name} could not play a card this turn."
      end
    end
  end
end
