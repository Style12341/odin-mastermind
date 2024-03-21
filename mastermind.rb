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

  def white_sq
    '■'
  end

  def get_color(color)
    colors = {
      'red' => red_sq,
      'green' => green_sq,
      'yellow' => yellow_sq,
      'blue' => blue_sq,
      'pink' => pink_sq,
      'lightblue' => light_blue_sq
    }
    colors[color]
  end
end

# Board class
class Board
  MAX_TURNS = 12
  CODE_LENGTH = 4
  include Squares
  attr_accessor :board, :title, :board_header

  def initialize
    @board = Array.new(MAX_TURNS) { Array.new(CODE_LENGTH, '□') }
    @info = Array.new(MAX_TURNS) { Array.new(CODE_LENGTH, '□') }
    @title = 'Mastermind'
    @board_header = '   Board' + 'Info  '.rjust(12)
  end

  def print_board
    puts @title.center(@board_header.length)
    puts @board_header
    @board.each_with_index do |row, idx|
      puts ' ' + row.join(' ') + '  ' + (@info[idx].join(' ') + '  ')
    end
  end

  def place_peg(color, row, column)
    @board[row][column] = get_color(color)
  end

  def remove_peg(row, column)
    @board[row][column] = blank_sq
  end

  def get_row(row)
    @board[row]
  end

  def set_info(row, exact_matches, color_matches)
    offset = 0
    exact_matches.times do |i|
      @info[row][i] = '■'.red
      offset += 1
    end
    color_matches.times { |i| @info[row][i + offset] = white_sq }
  end
end

# Mastermind class
class Mastermind
  include Squares
  MAX_TURNS = 12
  CODE_LENGTH = 4
  def initialize
    @board = Board.new
    @turn = 0 # Same as row
    @colors = %w[red green yellow blue pink lightblue]
    @state = 'playing'
    @code = generate_code
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
    input = gets.chomp.downcase
    if input == 'board'
      @board.print_board
    elsif input == 'instructions'
      print_instructions
    elsif input == 'confirm'
      confirm_guess
      return true
    elsif input == 'code'
      puts @code
    elsif input.include?('remove')
      input = input.split(' ')
      @board.remove_peg(@turn, input[1].to_i - 1)
    else
      input = input.split(' ')
      @board.place_peg(input[0], @turn, input[1].to_i - 1) if @colors.include?(input[0])
    end
    false
  end

  def confirm_guess
    compare_guess(current_guess)
  end

  def compare_guess(guess)
    exact_matches = 0
    color_matches = 0
    guess.each_with_index do |peg, idx|
      exact_matches += peg == @code[idx] ? 1 : 0
      color_matches -= peg == @code[idx] ? 1 : 0
    end
    guess.uniq.each { |peg| color_matches += @code.count(peg) }
    @board.set_info(@turn, exact_matches, color_matches)
    return @state = 'win' if exact_matches == CODE_LENGTH

    @state = 'lose' if @turn == MAX_TURNS - 1
  end

  def generate_code
    code = []
    CODE_LENGTH.times { code << get_color(@colors.sample) }
    code
  end

  def current_guess
    @board.get_row(@turn)
  end

  def play_as_codebreaker
    @board.print_board
    until @turn == MAX_TURNS || @state != 'playing'
      if parse_input
        @board.print_board
        @turn += 1
      end
    end
    announce_winner
  end

  def announce_winner
    if @state == 'win'
      puts 'You win!'
    else
      puts 'You lose!'
    end
  end
end

game = Mastermind.new
game.play_as_codebreaker
