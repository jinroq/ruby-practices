# frozen_string_literal: true

# FizzBuzz クラス
class FizzBuzz
  def run
    20.times do |n|
      if ((n + 1) % 15).zero?
        puts 'FizzBuzz'
      elsif ((n + 1) % 5).zero?
        puts 'Buzz'
      elsif ((n + 1) % 3).zero?
        puts 'Fizz'
      else
        puts n + 1
      end
    end
  end
end

FizzBuzz.new.run
