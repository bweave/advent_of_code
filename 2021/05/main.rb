require "bundler/inline"

gemfile do
  source "https://rubygems.org"

  gem "minitest"
  gem "pry"
end

require "minitest/autorun"

class Day5Test < Minitest::Test
  def input
    <<~TEST
      0,9 -> 5,9
      8,0 -> 0,8
      9,4 -> 3,4
      2,2 -> 2,1
      7,0 -> 7,4
      6,4 -> 2,0
      0,9 -> 2,9
      3,4 -> 1,4
      0,0 -> 8,8
      5,5 -> 8,2
    TEST
  end

  def test_horizontal_coord_pair
    subject = CoordinatePair.new([[0, 0], [2, 0]])
    expected = [
      [0, 0],
      [1, 0],
      [2, 0],
    ]
    actual = subject.line
    assert_equal expected, actual
  end

  def test_vertical_coord_pair
    subject = CoordinatePair.new([[0, 0], [0, 2]])
    expected = [
      [0, 0],
      [0, 1],
      [0, 2],
    ]
    actual = subject.line
    assert_equal expected, actual
  end

  def test_diagonal_coord_pair
    subject = CoordinatePair.new([[0, 0], [2, 2]])
    expected = [
      [0, 0],
      [1, 1],
      [2, 2],
    ]
    actual = subject.line
    assert_equal expected, actual
  end

  def test_part1
    assert_equal 5, HydrothermalVents.new(input).danger_zone_count
  end

  def test_part2
    assert_equal 12, HydrothermalVents.new(input, include_diagonals: true).danger_zone_count
  end
end

def danger_zone_count(input)
  input.split("\n")
       .map do |raw_coords|
         x1, y1, x2, y2 = raw_coords.split(" -> ").flat_map { |pair| pair.split(",") }.map(&:to_i)
         if x1 == x2
           ([y1, y2].min..[y1, y2].max).map { |y| [x1, y] }
         elsif y1 == y2
           ([x1, x2].min..[x1, x2].max).map { |x| [x, y1] }
         else
           ([x1, x2].min..[x1, x2].max).zip(([y1, y2].min..[y1, y2].max))
         end
       end
       .compact
       .flatten(1)
       .group_by(&:itself)
       .values
       .select { |g| g.size >= 2 }
       .count
end

class StraightLines
end

class HydrothermalVents
  attr_reader :coord_pairs, :include_diagonals

  def initialize(input, include_diagonals: false)
    @include_diagonals = include_diagonals
    @coord_pairs = input.split("\n")
      .map do |set|
        coords = set.split(" -> ").map do |pair|
          pair.split(",").map(&:to_i)
        end
        CoordinatePair.new(coords)
      end
  end

  def danger_zone_count
    lines
      .flatten(1)
      .group_by(&:itself)
      .values
      .count { |group| group.count >= 2 }
  end

  def lines
    if include_diagonals
      all_lines
    else
      straight_lines
    end
  end

  private
  
  def all_lines
    coord_pairs.map(&:line)
  end

  def straight_lines
    coord_pairs
      .select { |pair| [:horizontal, :vertical].include?(pair.type) }
      .map(&:line)
  end
end

class CoordinatePair
  attr_reader :x1, :y1, :x2, :y2

  def initialize(coord_pair)
    @x1, @y1, @x2, @y2 = *coord_pair.flatten
  end

  def line
    case type
    when :horizontal
      (min_x..max_x).map { |x| [x, y1] }
    when :vertical
      (min_y..max_y).map { |y| [x1, y] }
    when :diagonal
      diagonal_xs.zip(diagonal_ys)
    else
      raise "NOPE"
    end
  end

  def type
    if x1 == x2
      :vertical
    elsif y1 == y2
      :horizontal
    else
      :diagonal
    end
  end

  private

  def min_x
    [x1, x2].min
  end

  def max_x
    [x1, x2].max
  end

  def diagonal_xs
    x_range = (min_x..max_x).to_a
    x1 > x2 ? x_range.reverse : x_range
  end

  def min_y
    [y1, y2].min
  end

  def max_y
    [y1, y2].max
  end

  def diagonal_ys
    y_range = (min_y..max_y).to_a
    y1 > y2 ? y_range.reverse : y_range
  end
end

input = File.read("input.txt")
puts "=" * 40
puts "Part1: #{ HydrothermalVents.new(input).danger_zone_count}"
puts "Part2: #{ HydrothermalVents.new(input, include_diagonals: true).danger_zone_count}"
puts "=" * 40
