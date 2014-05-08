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
    "It's a #{face_value} of #{find_suit}'s"
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
      ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'].each do |face_value|
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
    if val == 'A'
      total += 11

    elsif 
      total += (val.to_i == 0 ? 10 : val.to_i)
    end
  end
  
  #correct for Aces
  face_value.select{|e| e == 'A'}.count.times do
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

end

class Blackjack
  attr_accessor :player, :dealer, :deck

  def initialize
    @player = Player.new
    @dealer = Dealer.new
    @deck = Deck.new
  end

  def run
    player.add_card(deck.deal_one)
    dealer.add_card(deck.deal_one)
    player.add_card(deck.deal_one)
    dealer.add_card(deck.deal_one)
    dealer.show_hand
    player.show_hand
   
   #player turn
    turn = 0
    while player.total < 21 && turn < 6
    puts "You have #{player.total}, what would you like to do, 1) for Hit, 2) for Stay?"
    choice = gets.chomp
      
      if choice == '1'
        player.add_card(deck.deal_one)
        player.show_hand
        turn += 1
      else
        break
      end # -- if choice

    end # -- while player
    
    if player.total == 21
      puts "Congratulations #{player.name}, you got blackjack you win" 
      exit
    end

    if player.total > 21
      puts "Sorry #{player.name}, you're Bust"
      exit
    end #end player turn

    #dealer turn
    turn = 0
    while dealer.total < 17 && turn < 6
    puts "Dealer hits"
    dealer.add_card(deck.deal_one)
    turn += 1
    end
    dealer.show_hand

    if dealer.total == 21
    puts "Sorry #{player.name}, the dealer got blackjack you lose"
    exit
  end

  if dealer.total > 21
    puts "The dealer is bust, you win!"
    exit

  elsif dealer.total > player.total
    puts "The dealer has #{dealer.total}, you have #{player.total}"
    puts "Sorry #{player.name}, the dealer wins"

  elsif dealer.total == player.total
    puts "The dealer has #{dealer.total}, you have #{player.total}"
    puts "It's a draw, no one wins"
    exit

  elsif player.total > dealer.total
    puts "Sweet, you have #{player.total}, the dealer has #{dealer.total}"
    puts "#{player.name} wins"
    exit
  end
  end # -- def run

end # -- class Blackjack 

Blackjack.new.run