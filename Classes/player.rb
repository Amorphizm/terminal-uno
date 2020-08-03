require_relative '../Modules/methods.rb'

# Describes a player object
class Player
  include Methods

  attr_accessor :name
  attr_accessor :hand

  def initialize(name)
    @name = name
    @hand = []
  end

  def draw_card(cards)
    card = cards.output_card
    @hand << card
    cards
  end

  def get_card(card_pos)
    # card_pos = verify_card(@hand)
    card = @hand[card_pos]
    @hand.delete_at(card_pos)
    card
  end

  def play_card(discard_pile)
    valid_card = false
    while valid_card == false
      print 'Enter the position of the card you want to play: '
      card_pos = gets.to_i - 1
      if @hand[card_pos].suit != 'none' # wild card check
        if (card_pos < 0) || (card_pos > @hand.length - 1)
          puts 'ERROR: The card position entered is invalid.'
        elsif (@hand[card_pos].suit != discard_pile.last.suit) && (@hand[card_pos].rank != discard_pile.last.rank)
          puts 'ERROR: The card position entered is invalid.'
        else
          selected_card = get_card(card_pos)
          valid_card = true
        end
      else
        selected_card = get_card(card_pos)
        valid_card = true
      end
    end
    selected_card
  end

  def uno_check
    puts "#{name} says UNO!" if @hand.length == 1
  end

  def won_check
    if @hand.empty?
      true
    else
      false
    end
  end

  def take_turn(discard_pile, cards)
    puts "Current card: #{discard_pile.last.suit} #{discard_pile.last.rank}"
    show_hand(@hand)
    draw = verify_hand(discard_pile, @hand)
    if draw != true
      played_card = play_card(discard_pile)
      played_card.suit = select_color if played_card.suit == 'none' # its a wild card
      discard_pile << played_card
    else
      draw_card(cards)
      if @hand.last.suit != 'none'
        puts "You have to draw a card - you drew a #{@hand.last.suit} #{@hand.last.rank} card."
      else
        puts "You have to draw a card - you drew a #{@hand.last.rank} card."
      end
      draw = verify_hand(discard_pile, @hand)
      if draw != true
        show_hand(@hand)
        played_card = play_card(discard_pile)
        played_card.suit = select_color if played_card.suit == 'none' # its a wild card
        discard_pile << played_card
      else
        puts 'You cannot play a card this turn.'
      end
    end
  end
end
