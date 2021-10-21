#!/usr/bin/env ruby
# frozen_string_literal: true

# Ls クラス
class Ls
  def initialize
    @files = Dir.glob('*')
  end

  def run
    list = create_list
    puts_list(list)
  end

  private

  def create_list(columns = 3)
    files = @files
    size = files.size

    lines = Array.new(size / columns, 0)
    lines.each_with_index do |_line, i|
      lines[i] = []
    end

    size.times do |i|
      lines[i % columns].push(files[i])
    end

    lines
  end

  def puts_list(list)
    list.each do |l|
      puts l.join('	')
    end
  end
end

Ls.new.run
