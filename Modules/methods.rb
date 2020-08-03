# frozen_string_literal: true

module Methods
  def show_hand(hand)
    print 'Your current hand: '
    count = 1
    hand.each do |card|
      if card.suit != 'none'
        print "#{count} - #{card.suit} #{card.rank} | "
      else
        print "#{count} - #{card.rank} | "
      end
      count += 1
    end
    print "\n"
  end

  def verify_card(hand)
    valid = false
    until valid == true
      show_hand(hand)
      print 'Type in the card position you would like to play: '
      card = gets.to_i
      if (card > hand.length) || (card < 1)
        puts 'ERROR - Please enter the card position number.'
      else
        valid = true
      end
    end
    card - 1
  end

  def verify_player
    print 'Player name (.bot on the end for a bot): '
    name = gets.chomp
    if !name.include?('.bot')
      player = Player.new(name)
    else
      name.gsub!('.bot')
      player = Bot.new(name)
    end
    player
  end

  def verify_player_amount
    valid = false
    while valid == false
      print 'Enter the number of players: '
      number = gets.chomp.to_i
      if (number.to_i > 10) || (number.to_i < 1)
        puts 'ERROR - Please enter the the player amount again.'
      else
        valid = true
      end
    end
    number
  end

  def verify_hand(discard_pile, hand)
    count = 0
    draw = false
    hand.each do |card|
      next unless card.suit != 'none' # wild card check

      count += 1 if (card.suit != discard_pile.last.suit) && (card.rank != discard_pile.last.rank)
    end
    draw = true if count == hand.length
    draw
  end

  def select_color
    valid_color = false
    while valid_color == false
      print 'Type in the color you would like to pick: '
      color = gets.chomp.downcase.capitalize
      case color
      when 'Green'
        valid_color = true
      when 'Yellow'
        valid_color = true
      when 'Blue'
        valid_color = true
      when 'Red'
        valid_color = true
      else
        puts 'ERROR: Invalid color.'
      end
    end
    color
  end

  def reverse_array(player_index, player_array)
    array_reversed = []
    count = 0
    until count == player_array.length
      next_player = player_array[player_array.index(player_array[player_index]) - 1]
      if player_array.index(next_player) < 0
        next_player = player_array[player_array.length - 1]
      elsif player_array.index(next_player) > player_array.length - 1
        next_player = player_array[0]
      end
      array_reversed << next_player
      player_index -= 1
      count += 1
    end
    array_reversed
  end
end
