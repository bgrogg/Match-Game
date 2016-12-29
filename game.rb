require 'byebug'
require_relative 'board'
require_relative 'card'
require_relative 'player'

class Game
  attr_reader :board

  def initialize(size = 5, player = ComputerPlayer.new)
    @board = Board.new(size)
    @guess = nil
    @previous_guess = nil
    @player = player
  end

  def play
    @board.populate

    until over?
      board.render
      # system("clear")
      puts ""
      loop do
        @guess = @player.prompt(@previous_guess, @board)
        break if valid_play?
        puts "You cannot select that card."
      end

      make_guess(@guess)
    end

    board.render
    puts "Congratulations, you've matched all the cards!"
  end

  def make_guess(guess)

    @board[guess].reveal
    @player.store_position(@board[guess].face_value, @guess)

    if @previous_guess
      unless @board[guess] == @board[@previous_guess]
        board.render
        sleep(4)
        system("clear")
        @board[guess].hide
        @board[@previous_guess].hide
      end

      @previous_guess = nil
    else
      @previous_guess = guess
    end

  end

  def over?
    @board.won?
  end

  def valid_play?
    # debugger
    !@board[@guess].face_up && @previous_guess != @guess
  end
end

a = Game.new(5)
a.play
