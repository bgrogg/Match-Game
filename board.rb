require_relative 'card'
require 'byebug'

class Board
  attr_reader :grid, :size

  def initialize(size = 10)
    @size = size
    @grid = Array.new(size) { Array.new(2) }
  end

  def populate
    card_values = []

    size.times do |i|
      2.times { card_values << i + 1 }
    end
    # byebug

    card_values = card_values.shuffle

    card_values.each_with_index do |value, index|
      self[[index % size, index / size]] = Card.new(value)
    end
  end

  def render
    @grid.each do |row|
      row.each do |card|
        if card.face_up
          card.display
        else
          print "X"
        end
      end

      puts ""
    end
  end

  def [](pos)
    @grid[pos.first][pos.last]
  end

  def []=(pos, value)
    @grid[pos.first][pos.last] = value
  end

  def won?
    grid.flatten.all?(&:face_up)
  end

  def reveal(guess_pos)
    self[guess_pos].reveal unless self[guess_pos].face_up
  end

end

# a = Board.new
# a.populate
# # p a.grid
# a.reveal([4, 0])
# a.render
