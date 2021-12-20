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
      3,4,3,1,2
    TEST
  end

  def test_part1
    # assert_equal 5_934, LanternFish.parse(input).multiply_for_days(80)
    assert_equal 5_934, LanternFishV2.parse(input).multiply_for_days(80)
  end

  def test_part1_v2
  end

  def test_part2
    # assert_equal 26_984_457_539, LanternFish.parse(input).multiply_for_days(256)
    assert_equal 26_984_457_539, LanternFishV2.parse(input).multiply_for_days(256)
  end
end

LanternFish = Struct.new(:fishes) do
  def self.parse(input)
    fishes = input.split(",").map(&:to_i)
    new(fishes)
  end

  def multiply_for_days(days)
    days.times.reduce(fishes) do |current_fishes, day|
      new_fishes = current_fishes.flat_map do |fish|
        if fish == 0
          [6, 8]
        else
          [fish -= 1]
        end
      end
      
      new_fishes
    end.size
  end
end

LanternFishV2 = Struct.new(:fish_tally) do
  def self.parse(input)
    initial_tally = {0 => 0, 1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0, 7 => 0, 8 => 0}
    fish_tally = input.split(",").map(&:to_i).tally
    new(initial_tally.merge(fish_tally))
  end

  def multiply_for_days(days)
    days.times.reduce(fish_tally) do |current_fish|
      {
        0 => current_fish.fetch(1),
        1 => current_fish.fetch(2),
        2 => current_fish.fetch(3),
        3 => current_fish.fetch(4),
        4 => current_fish.fetch(5),
        5 => current_fish.fetch(6),
        6 => current_fish.fetch(7) + current_fish.fetch(0),
        7 => current_fish.fetch(8),
        8 => current_fish.fetch(0),
      }
    end.values.sum
  end
end

input = File.read(File.join(__dir__, "input.txt"))
puts "=" * 40
puts "Part1: #{LanternFishV2.parse(input).multiply_for_days(80)}"
puts "Part1: #{LanternFishV2.parse(input).multiply_for_days(256)}"
puts "=" * 40
