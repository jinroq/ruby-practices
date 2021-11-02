#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

# Ls クラス
class Ls
  def initialize
    opt = OptionParser.new
    params = {}

    opt.on('-a') { |v| params[:a] = v }
    opt.parse!(ARGV)

    @files = params.empty? ? Dir.glob('*') : Dir.glob('*', File::FNM_DOTMATCH)
  end

  def run
    lines = create_lines
    puts_list(lines)
  end

  private

  def create_lines(columns = 3)
    files = @files
    size = files.size

    lines = Array.new(size / columns) { [] }
    max_line = lines.length

    files.each_with_index do |file, i|
      lines[i % max_line].push(file)
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
