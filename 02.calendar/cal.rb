#!/usr/bin/env ruby 

require 'date'
require 'optparse'

class Cal
  SUNDAY_ORIGIN_WEEKS = ['日','月','火','水','木','金','土']

  def initialize
    params = OptionParser.new.getopts("m:y:")

    today = Date.today
    if params['m'] && params['y']
      @current = Date.new(params["y"].to_i, params['m'].to_i, 1)
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
      if 1 == (day + 1)
        weeks.push('  ')
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
        if current_month_first_day.friday?
          weeks.push(current_month_first_day.strftime('%e'))
          next
        end

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
        if current_day.saturday?
          weeks.push(current_day.strftime('%e'))
          puts weeks.join(' ')
          weeks = []
        else
          weeks.push(current_day.strftime('%e'))
        end
      end
    end
  end

  private

  def puts_header
    puts "#{' '*6}#{@current.month}月 #{@current.year}"
    weeks_header = SUNDAY_ORIGIN_WEEKS.join(' ')
    puts "#{weeks_header}"
  end

end

Cal.new.run
