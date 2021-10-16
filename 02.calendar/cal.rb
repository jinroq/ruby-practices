#!/usr/bin/env ruby
# frozen_string_literal: true

require 'date'
require 'optparse'

# Cal クラス
class Cal
  SUNDAY_ORIGIN_WEEKS = %w[日 月 火 水 木 金 土]

  def initialize
    SUNDAY_ORIGIN_WEEKS.freeze
    params = OptionParser.new.getopts('m:y:')

    today = Date.today
    if params['m'] && params['y']
      @current = Date.new(params['y'].to_i, params['m'].to_i, 1)
    elsif params['m']
      @current = Date.new(today.year, params['m'].to_i, 1)
    else
      @current = today
    end
  end

  def run
    puts_header

    current_month_first_day = Date.new(@current.year, @current.month, 1)
    current_month_last_day = Date.new(@current.year, @current.month, -1)

    last_day = current_month_last_day.day
    weeks = []
    last_day.times do |day|
      if (day + 1) == 1
        if current_month_first_day.sunday?
          weeks.push(current_month_first_day.strftime('%e'))
          next
        end

        weeks.push('  ')
        if current_month_first_day.monday?
          weeks.push(current_month_first_day.strftime('%e'))
          next
        end

        weeks.push('  ')
        if current_month_first_day.tuesday?
          weeks.push(current_month_first_day.strftime('%e'))
          next
        end

        weeks.push('  ')
        if current_month_first_day.wednesday?
          weeks.push(current_month_first_day.strftime('%e'))
          next
        end

        weeks.push('  ')
        if current_month_first_day.thursday?
          weeks.push(current_month_first_day.strftime('%e'))
          next
        end

        weeks.push('  ')
        if current_month_first_day.friday?
          weeks.push(current_month_first_day.strftime('%e'))
          next
        end

        weeks.push('  ')
        # ここまでくれば土曜日のはず
        weeks.push(current_month_first_day.strftime('%e'))
        puts weeks.join(' ')
        weeks = []
      elsif (day + 1) == last_day
        current_day = current_month_first_day + day
        weeks.push(current_day.strftime('%e'))
        puts weeks.join(' ')
      else
        current_day = current_month_first_day + day
        weeks.push(current_day.strftime('%e'))
        if current_day.saturday?
          puts weeks.join(' ')
          weeks = []
        end
      end
    end
  end

  private

  def puts_header
    puts "#{' ' * 6}#{@current.month}月 #{@current.year}"
    weeks_header = SUNDAY_ORIGIN_WEEKS.join(' ')
    puts weeks_header.to_s
  end
end

Cal.new.run
