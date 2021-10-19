#!/usr/bin/env ruby
# frozen_string_literal: true

# Bowling クラス
class Bowling
  MAX_FRAME = 10
  MAX_POINT_OF_ONE_THROW = 10
  MAX_POINT_OF_ONE_FRAME = 10

  def initialize
    argv = ARGV[0]
    raise 'おじさん、そういう事する子、嫌い。' if argv.nil?

    @args = argv.split(',')
  end

  def run
    shots = create_shots

    frames = create_frames(shots)

    point = calculate_point(frames)

    puts point
  end

  private

  def create_shots
    shots = []
    @args.each do |s|
      if s == 'X'
        shots << 10
        shots << 0
      else
        shots << s.to_i
      end
    end

    shots
  end

  def create_frames(shots)
    frames = []
    shots.each_slice(2) do |s|
      frames << s
    end
    if frames.size > MAX_FRAME
      if frames.size == (MAX_FRAME + 1)
        last = frames.delete_at(MAX_FRAME)
        frames[MAX_FRAME - 1] << last[0]
      elsif frames.size == (MAX_FRAME + 2)
        last = frames.delete_at(MAX_FRAME + 1)
        second = frames.delete_at(MAX_FRAME)
        frames[MAX_FRAME - 1][1] = second[0]
        frames[MAX_FRAME - 1] << last[0]
      else
        # ここに来ることはないので何もしない。
      end
    end

    frames
  end

  def calculate_point(frames)
    point = 0
    MAX_FRAME.times do |i|
      if strike?(frames[i])
        point += get_strike(frames, i)
      elsif spare?(frames[i])
        point += get_spare(frames, i)
      else
        point += frames[i].sum
      end
    end

    point
  end

  def strike?(frame)
    frame[0] == MAX_POINT_OF_ONE_THROW
  end

  def spare?(frame)
    frame.sum == MAX_POINT_OF_ONE_FRAME
  end

  def get_strike(frames, index)
    point = 0
    if index <= 7
      if strike?(frames[index + 1])
        point += 10 + 10 + frames[index + 2][0]
      else
        point += 10 + frames[index + 1].sum
      end
    elsif index == 8
      point += 10 + frames[index + 1][0] + frames[index + 1][1]
    else # ここに来るのは 10 フレーム目のみ
      point += frames[index].sum
    end

    point
  end

  def get_spare(frames, index)
    point = 0
    if index <= 8
      point += 10 + frames[index + 1][0]
    else # ここにくるのは 10 フレーム目のみ
      point += frames[index].sum
    end

    point
  end
end

Bowling.new.run
