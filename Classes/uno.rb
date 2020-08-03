# frozen_string_literal: true

require_relative 'card.rb'
require_relative 'deck.rb'
require_relative 'player.rb'
require_relative 'bot.rb'
require_relative '../Modules/methods.rb'

class Uno
  include Methods

  def initialize
    @num_players = verify_player_amount
    @players = []
    @discard_pile = []
    @over = false
    @cards = Deck.new
    @won = false
  end

  def create_players
    count = 1
    while count <= @num_players
      @players << verify_player
      count += 1
    end
  end

  def deal_cards(card_amount)
    @players.each do |player|
      count = 0
      until count == card_amount
        player.draw_card(@cards)
        count += 1
      end
    end
  end

  def start_discard
    valid_start = false
    while valid_start == false
      if (@cards.deck[0].suit == 'none') || (@cards.deck[0].rank == 'Reverse')
        @cards.deck.shuffle!
      else
        valid_start = true
      end
    end
    @discard_pile << @cards.deck[0]
    @cards.deck.delete_at(0)
  end

  def deck_check
    @cards = Deck.new if @cards.deck.empty?
  end

  def player_iteration
    while @won == false
      @players.each do |player|
        deck_check
        if (@discard_pile.last.rank == 'Skip') && (@discard_pile.last.used == false)
          puts "Skipping #{player.name}'s turn."
          @discard_pile.last.used = true
        elsif (@discard_pile.last.rank == 'Draw2') && (@discard_pile.last.used == false)
          puts "#{player.name} drew 2 cards and got their turn skipped."
          count = 0
          while count <= 1
            player.draw_card(@cards)
            count += 1
          end
          @discard_pile.last.used = true
        elsif (@discard_pile.last.rank == 'Wild+4') && (@discard_pile.last.used == false)
          puts "#{player.name} drew 4 cards and got their turn skipped."
          count = 0
          while count <= 3
            player.draw_card(@cards)
            count += 1
          end
          @discard_pile.last.used = true
        else
          puts "#{player.name}'s turn."
          player.take_turn(@discard_pile, @cards)
          if player.won_check == true
            puts "#{player.name} is the winner!"
            @won = true
            exit
          else
            player.uno_check
            if (@discard_pile.last.rank == 'Reverse') && (@discard_pile.last.used == false)
              puts 'Reversing the order.'
              @players = reverse_array(@players.index(player), @players)
              @discard_pile.last.used = true
              player_iteration
            end
          end
        end
      end
    end
  end

  def start
    create_players
    deal_cards(7)
    start_discard
    player_iteration
  end
end
