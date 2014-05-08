require 'pry'
# Have detailed requirements or specs in written form
# Extract major nouns -> classes
# Extract major verbs -> instance methods
# Group instance methods into classes

# Major nouns
# Card
# Deck
# Hand
# Player
# Dealer

#Major verbs
# New player welcome
# New player name
# Build deck
# Shuffle cards
# Deal cards
# Show Hands
# Calculate Hands
# Show calculations
# Player turn
# Hits  -> add new card
# Stays
# Dealer turn
# Hits  -> add new card
# Stays
# Compare cards
# Play Again


#Blackjack requirements

class Card
  attr_accessor :suit, :face_value

  def initialize(s,fv)
    @suit = s
    @face_value = fv
  end

  def show_cards
    "The #{face_value} of #{find_suit}'s"
  end

  def to_s
    show_cards
  end

  def find_suit
      ret_val = case suit
                  when 'H' then 'Hearts'
                  when 'D' then 'Diamonds'
                  when 'S' then 'Spades'
                  when 'C' then 'Clubs' 
                end
      ret_val 
  end  
end

class Deck
attr_accessor :cards

  def initialize
    @cards = []
    ['H', 'D', 'S', 'C'].each do |suit|
      ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace'].each do |face_value|
      @cards << Card.new(suit, face_value)
      end
    end
    scramble
  end

  def scramble
    cards.shuffle!
  end
  
  def deal_one
    cards.pop
  end

  def size
    cards.size
  end

end

module Hand

  def show_hand
    puts "---- #{name}'s Hand ----"
    cards.each do |card|
      puts "=> #{card}"
    end
    puts "=> Total: #{total}"
  end

  def total
  face_value = cards.map{|card| card.face_value }

  total = 0
  face_value.each do |val|
    if val == 'Ace'
      total += 11

    elsif 
      total += (val.to_i == 0 ? 10 : val.to_i)
    end
  end
  
  #correct for Aces
  face_value.select{|e| e == 'Ace'}.count.times do
    break if total<= 21
    total -= 10
  end

  total
  end

  def add_card(new_card)
    cards << new_card
  end

  def is_busted?
    total > 21
  end

end

class Player
include Hand

attr_accessor :name, :cards

  def initialize
  puts "What's your name?"
  @name = gets.chomp.capitalize
  puts "Hi #{name}"
  @cards = []
  end

  def show_flop
    show_hand
  end

end

class Dealer
  include Hand

  attr_accessor :name, :cards

  def initialize
  @name = "Dealer"
  puts "#{name} is ready"
  @cards = []  
  puts "*#{name} deals cards*"
  end

  def show_flop
    puts "---- #{name}'s Hand ----"
    puts "=> First card is hidden"
    puts "=> Second card is #{cards[1]}"
  end
end

class Blackjack
  attr_accessor :player, :dealer, :deck

  def initialize
    @player = Player.new
    @dealer = Dealer.new
    @deck = Deck.new
  end

  def deal_cards
    player.add_card(deck.deal_one)
    dealer.add_card(deck.deal_one)
    player.add_card(deck.deal_one)
    dealer.add_card(deck.deal_one)
  end

  def show_flop
    player.show_flop
    dealer.show_flop
  end


  def player_turn
    
    turn = 0
    while player.total < 21 && turn < 5
    puts "#{player.name} has #{player.total}, choose 1) for Hit, 2) for Stay?"
    choice = gets.chomp
      
      if !['1', '2'].include?(choice)
        puts "Error: you must enter 1 or 2"
      next
      end

      if choice == '1'
        player.add_card(deck.deal_one)
        player.show_hand
        turn += 1
      end

      if choice == '2'  
        puts "You chose to stay."
        break
      end # -- if choice

    end # -- while player
    
    if player.total == 21
      puts "#{player.name}, got blackjack #{player.name} wins" 
      play_again
    end

    if player.is_busted?
      puts "#{player.name}, is Bust"
      play_again
    end

  end

  def dealer_turn
    
    turn = 0
    while dealer.total < 17 && turn < 6
      puts "Dealer hits"
      dealer.add_card(deck.deal_one)
      turn += 1
    end

    dealer.show_hand
    if dealer.total == 21
      puts "Sorry #{player.name}, the dealer got blackjack you lose"
      play_again
    end
  end

  def who_won?(player, dealer)
    
    if dealer.total > 21
      puts "The dealer is bust, you win!"
      play_again
    #compare cards
    elsif dealer.total > player.total
      puts "The dealer has #{dealer.total}, #{player.name} has #{player.total}"
      puts "Sorry #{player.name}, the dealer wins"
    elsif dealer.total == player.total
      puts "The dealer has #{dealer.total}, #{player.name} has #{player.total}"
      puts "It's a draw, no one wins"
      play_again
    elsif player.total > dealer.total
      puts "#{player.name} has #{player.total}, the dealer has #{dealer.total}"
      puts "#{player.name} wins"
      play_again
    end
  
  end

  def play_again
    puts "Want to play again Y) for yes or N) for no?"
    answer = gets.chomp.downcase
    
    if answer == 'y'
      Blackjack.new.run
    else
      exit
    end

  end

  def run
    deal_cards
    show_flop
    player_turn
    dealer_turn
    who_won?(player, dealer) 
    play_again
  end

end

Blackjack.new.run

