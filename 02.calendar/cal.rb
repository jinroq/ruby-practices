#!/usr/bin/env ruby 

require 'date'
require 'optparse'

class Cal
  SUNDAY_ORIGIN_WEEKS = ['日','月','火','水','木','金','土']

  def initialize
    @today = Date.today
  end

  def run
    puts_header

    current_month_first_day = Date.new(@today.year, @today.month, 1)
#    puts current_month_first_day
    current_month_last_day = Date.new(@today.year, @today.month, -1)
#    puts current_month_last_day

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
    puts "#{' '*6}#{@today.month}月 #{@today.year}"
    weeks_header = SUNDAY_ORIGIN_WEEKS.join(' ')
    puts "#{weeks_header}"
  end
end

Cal.new.run
