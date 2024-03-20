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
    '■'.red
  end

  def green_sq
    '■'.green
  end

  def yellow_sq
    '■'.yellow
  end

  def blue_sq
    '■'.blue
  end

  def pink_sq
    '■'.pink
  end

  def light_blue_sq
    '■'.light_blue
  end

  def blank_sq
    '□'
  end
end

# Board class
class Board
  include Squares
  attr_accessor :board, :title, :board_header

  def initialize
    @board = Array.new(12) { Array.new(4, '□') }
    @info = Array.new(12) { Array.new(4, '□') }
    @title = 'Mastermind'
    @board_header = '   Board' + 'Info  '.rjust(12)
  end

  def print_board
    puts @title.center(@board_header.length)
    puts @board_header
    @board.each_with_index do |row, idx|
      puts row.join(' ').rjust(9) + (@info[idx].join(' ') + '  ').rjust(12)
    end
  end

  def place_peg(color, row, column)
    case color
    when 'red'
      @board[row][column] = red_sq
    when 'green'
      @board[row][column] = green_sq
    when 'yellow'
      @board[row][column] = yellow_sq
    when 'blue'
      @board[row][column] = blue_sq
    when 'pink'
      @board[row][column] = pink_sq
    when 'lightblue'
      @board[row][column] = light_blue_sq
    end
  end

  def remove_peg(row, column)
    @board[row][column] = blank_sq
  end
end

# Mastermind class
class Mastermind
  def initialize
    @board = Board.new
    @turn = 0 # Same as row
    @code = generate_code
    @colors = %w[red green yellow blue pink lightblue]
  end

  def print_instructions
    puts 'Welcome to Mastermind!'
    puts 'To place a peg, type the color of the peg and the row number'
    puts "For example, to place a red peg in row 1, type 'red 1'"
    puts "The colors are #{'red'.red}, #{'green'.green}, #{'yellow'.yellow}, #{'blue'.blue}, #{'pink'.pink}, and #{'lightblue'.light_blue}"
    puts "To remove a peg, type 'remove' and the row number"
    puts "To see the board, type 'board'"
    puts "To see the instructions, type 'instructions'"
    puts "To confirm a guess, type 'confirm'"
  end

  def parse_input
    input = gets.chomp.downcase.split(' ').map(&:i)
    if input == 'board'
      @board.print_board
    elsif input == 'instructions'
      print_instructions
    elsif input == 'confirm'
      confirm_guess
      return true
    elsif input.include?('remove')
      @board.remove_peg(@turn, input[1])
    else
      @board.place_peg(input[0], @turn, input[1])
    end
    false
  end

  def confirm_guess; end

  def play_as_codebreaker
    loop do
      @board.print_board
      puts "Turn: #{@turn + 1}"
      until parse_input
      end
      @turn += 1
    end
  end
end
board = Board.new
board.print_instructions
