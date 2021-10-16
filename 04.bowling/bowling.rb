#!/usr/bin/env ruby
# frozen_string_literal: true

# Bowling クラス
class Bowling
  MAX_FRAME = 10

  def initialize
    args = ARGV[0]
    raise 'おじさん、そういう事する子、嫌い。' if args.nil?
    @score = args.split(',')
  end

  def run
  end
end

Bowling.new.run
