#!/usr/bin/env ruby
# frozen_string_literal: true

# Ls クラス
class Ls
  def initialize
    @files = Dir.glob('*')
  end

  def run
    lines = create_lines
    puts_list(lines)
  end

  private

  def create_lines(columns = 3)
    files = @files
    size = files.size

    lines = Array.new(size / columns, 0)
    lines.each_with_index do |_line, i|
      lines[i] = []
    end

    files.each_with_index do |file, i|
      lines[i % columns].push(file)
    end

    lines
  end

  def puts_list(lines)
    lines.each do |l|
      puts l.join('	')
    end
  end
end

Ls.new.run
