require "bundler/inline"

gemfile do
  source "https://rubygems.org"

  gem "minitest"
  gem "pry"
end

require "minitest/autorun"

class Day4Test < Minitest::Test
  def input
    <<~TEST
      7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

      22 13 17 11  0
       8  2 23  4 24
      21  9 14 16  7
       6 10  3 18  5
       1 12 20 15 19

       3 15  0  2 22
       9 18 13 17  5
      19  8  7 25 23
      20 11 10 24  4
      14 21 16 12  6

      14 21 17 24  4
      10 16 15  9 19
      18  8 23 26 20
      22 11 13  6  5
       2  0 12  3  7
    TEST
  end

  def test_part1
    game = Bingo.new(input, strategy: FirstWinner).play
    assert_equal 4512, game.score
  end

  def test_part2
    game = Bingo.new(input, strategy: LastWinner).play
    assert_equal 1924, game.score
  end
end

class FirstWinner
  attr_reader :winner

  def initialize
    @winner = nil
  end

  def check_for_winners(boards)
    self.winner = boards.find(&:winner?)
  end

  def call_next_number?
    winner.nil?
  end

  def score
    winner.score
  end

  private

  attr_writer :winner
end

class LastWinner
  attr_reader :winners, :call_next_number

  def initialize
    @winners = Set.new
    @call_next_number = true
  end

  def check_for_winners(boards)
    winners.merge(boards.find_all(&:winner?))
    self.call_next_number = boards.any?(&:incomplete?)
  end

  def call_next_number?
    call_next_number
  end

  def score
    winners.to_a.last.score
  end

  private

  attr_writer :winners, :call_next_number
end

class Bingo
  attr_reader :numbers_to_call, :boards, :strategy
  attr_accessor :called_numbers

  def initialize(input, strategy:)
    raw_numbers, *raw_boards = input.split("\n\n")
    @numbers_to_call = raw_numbers.split(",")
    @boards = raw_boards.map { |raw_board| Board.new(raw_board) }
    @called_numbers = []
    @strategy = strategy.new
  end

  def play
    numbers_to_call.each do |called_number|
      boards.each { |board| board.play(called_number) }
      called_numbers << called_number

      strategy.check_for_winners(boards)
      break unless strategy.call_next_number?
    end

    self
  end

  def score
    strategy.score * called_numbers.last.to_i
  end
end

class Board
  attr_reader :rows, :columns

  def initialize(input)
    raw_rows = input.split("\n").map(&:split)
    @rows = raw_rows.map { |raw_row| Row.new(raw_row) }
    @columns = raw_rows.transpose.map { |raw_column| Row.new(raw_column) }
  end

  def play(number)
    return if winner?

    (rows + columns).each { |row| row.play(number) }
  end

  def winner?
    (rows + columns).any?(&:winner?)
  end

  def incomplete?
    !winner?
  end

  def score
    rows.sum(&:score)
  end
end

class Row
  attr_reader :cells

  def initialize(input)
    @cells = input.map { |cell| Cell.new(cell) }
  end

  def play(number)
    cells.each { |cell| cell.play(number) }
  end

  def winner?
    cells.all?(&:marked?)
  end

  def score
    cells.find_all(&:unmarked?).map(&:to_i).sum
  end
end

class Cell
  attr_reader :value
  attr_accessor :marked

  def initialize(value)
    @value = value
    @marked = false
  end

  def play(number)
    return if marked?

    self.marked = number == value
  end

  def marked?
    marked
  end

  def unmarked?
    !marked?
  end

  def to_i
    value.to_i
  end
end

input = File.read(File.join(__dir__, "input.txt"))
puts "=" * 40
puts "Part1: #{Bingo.new(input, strategy: FirstWinner).play.score}"
puts "Part2: #{Bingo.new(input, strategy: LastWinner).play.score}"
puts "=" * 40
