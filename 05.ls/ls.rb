#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

# Ls クラス
class Ls
  def initialize
    opt = OptionParser.new
    @params = {}

    opt.on('-a') { |v| @params[:a] = v }
    opt.on('-r') { |v| @params[:r] = v }
    opt.parse!(ARGV)

    @files =
      if @params.empty? || @params[:r]
        Dir.glob('*')
      else
        Dir.glob('*', File::FNM_DOTMATCH)
      end
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

    files = files.reverse if @params[:r]
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
