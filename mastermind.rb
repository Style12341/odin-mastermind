# source:https://stackoverflow.com/questions/1489183/how-can-i-use-ruby-to-colorize-the-text-output-to-a-terminal

# Frozen_string_literal: true

# Adds color to the output of strings
class String
  # colorization
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def red
    colorize(31)
  end

  def green
    colorize(32)
  end

  def yellow
    colorize(33)
  end

  def blue
    colorize(34)
  end

  def pink
    colorize(35)
  end

  def light_blue
    colorize(36)
  end
end

# Module to print colored squares
module Squares
  def red_sq
    puts '■'.red
  end

  def green_sq
    puts '■'.green
  end

  def yellow_sq
    puts '■'.yellow
  end

  def blue_sq
    puts '■'.blue
  end

  def pink_sq
    puts '■'.pink
  end

  def light_blue_sq
    puts '■'.light_blue
  end

  def blank_sq
    puts '□'
  end
end


