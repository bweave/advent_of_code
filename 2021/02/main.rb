require "bundler/inline"

gemfile do
  source "https://rubygems.org"

  gem "minitest"
  gem "pry"
end

require "minitest/autorun"

class Day2Test < Minitest::Test
  def input
    <<~TEST
      forward 5
      down 5
      forward 8
      up 3
      down 8
      forward 2
    TEST
  end

  def test_part1
    result = Part1.new(input).call
    expected = (5 + 8 + 2) * (5 - 3 + 8) #=> 150
    assert_equal expected, result
  end

  def test_part2
    # forward 5 => h:5, d:0, a:0
    # down 5    => h:5, d:0, a:5
    # forward 8 => h:5+8=13, d:0+8*5=40, a:5
    # up 3      => h:13, d:40, a:5-3=2
    # down 8    => h:13, d:40, a:2+8=10
    # forward 2 => h:13+2=15, d:40+2*10=60, a:10
    # h * d = 15 * 60 = 900

    result = Part2.new(input).call
    assert_equal 900, result
  end
end

class Part1
  attr_reader :input
  attr_accessor :position

  def initialize(input)
    @input = input.split("\n")
    @position = {horizontal: 0, depth: 0}
  end

  def call
    input.reduce(position) do |acc, movement|
      direction, amount_string = movement.split
      amount = amount_string.to_i
      case direction
      when "forward"
        acc[:horizontal] += amount
      when "down"
        acc[:depth] += amount
      when "up"
        acc[:depth] -= amount
      else
        raise "#{direction} is an unknown direction"
      end

      acc
    end.values.reduce(:*)
  end
end

class Part2
  attr_reader :input
  attr_accessor :position

  def initialize(input)
    @input = input.split("\n")
    @position = {horizontal: 0, depth: 0, aim: 0}
  end

  def call
    input.reduce(position) do |acc, movement|
      direction, amount_string = movement.split
      amount = amount_string.to_i
      case direction
      when "forward"
        acc[:horizontal] += amount
        acc[:depth] += acc[:aim] * amount
      when "down"
        acc[:aim] += amount
      when "up"
        acc[:aim] -= amount
      else
        raise "#{direction} is an unknown direction"
      end

      acc
    end

    position[:horizontal] * position[:depth]
  end
end

input = File.read(File.join(__dir__, "input.txt"))
puts "=" * 80
puts  "Part1: #{Part1.new(input).call}"
puts  "Part2: #{Part2.new(input).call}"
puts "=" * 80
