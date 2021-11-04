#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

# Ls クラス
class Ls
  def initialize
    opt = OptionParser.new
    params = {}

    opt.on('-a') { |v| params[:a] = v }
    opt.on('-r') { |v| params[:r] = v }
    opt.on('-l') { |v| params[:l] = v }
    opt.parse!(ARGV)

    @files = params[:a] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
    @files = @files.reverse if params[:r]
    @list_flag = params[:l]
  end

  def run
    lines = create_lines
    puts_list(lines)
  end

  private

  def create_lines(columns = 3)
    files = @files
    size = files.size

    lines = @list_flag ? [] : Array.new(size / columns) { [] }
    if @list_flag
      files.each do |file|
        lines.push(file)
      end
    else
      max_line = lines.length

      files.each_with_index do |file, i|
        lines[i % max_line].push(file)
      end
    end

    lines
  end

  def puts_list(lines)
    if @list_flag
      puts lines
    else
      lines.each do |l|
        puts l.join('	')
      end
    end
  end
end

Ls.new.run
