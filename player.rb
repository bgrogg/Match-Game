require 'byebug'
require_relative 'board'
require_relative 'card'

class HumanPlayer

  def prompt(previous_guess, board) #need to add player class here
    puts "Pick a card."
    get_input
  end

  def get_input
    gets.chomp.split(",").map(&:to_i)
  end
end


class ComputerPlayer

  def initialize
    @known_cards = Hash.new { |h, k| h[k] = [] }
    @matched_cards = []
    @board = nil
  end

  def prompt(previous_guess, board)
    @board = board
    if previous_guess
      return second_guess
    else
      first_guess
    end
  end

  def first_guess
    @matched_cards = []
    if any_match?
      #debugger
      return @matched_cards.first
    end

    get_random_card
  end

  def second_guess
    #debugger
    unless @matched_cards.empty?
      return @matched_cards.last
    end

    if any_match?
      return @matched_cards.first
    end

    get_random_card
  end

  def any_match?
    @known_cards.each do |key, positions|
      if positions.length > 1
        @matched_cards = positions
        @known_cards.delete(key)
        return true
      end
    end

    false
  end

  def get_random_card
    position = [rand(@board.size), rand(2)]
    return get_random_card if @board[position].face_up

    @known_cards.values.each do |value|
      value.each do |known_pos|
        return get_random_card if position == known_pos
      end
    end

    position
  end

  def store_position(value, guess)
    @known_cards[value] << guess
  end
end
