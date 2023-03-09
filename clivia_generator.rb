require "json"
require "httparty"
require "terminal-table"
require "htmlentities"
require "colorize"
require_relative "presenter"
require_relative "handler"

class CliviaGenerator
  include HTTParty
  include Presenter
  include Handler

  base_uri("https://opentdb.com/api.php?amount=10&")
  # maybe we need to include a couple of modules?

  def initialize(filename)
    @filename = filename
  end

  def start
    print welcome.blue
    action = ""
    until action == "exit"
      action = menu_options
      case action
      when "random" then random_trivia
      when "scores" then print_scores
      when "exit" 
        puts "Made with \u2665 by Kevin"
        puts "Thanks for using CLIvia"
        action
      end
    end
  end

  def random_trivia
    data = load_questions
    counter = 0
    data.each do |datos|
      counter += 1 if ask_questions(datos)
    end
    score = counter*10
    puts "Well done! Your score is #{score}".green.bold
    puts "-"*60
    save_score(score) if ask_safe_score == "Y"
    print welcome.blue
  end

  def save_score(score)
    puts "Type the name to assign to the score"
    print "> "
    input = gets.chomp
    if input.empty?
      input = "Anonymous"
    else
      input
    end
    new_score = {name: input, score: score}
    parse_score = JSON.parse(File.read(@filename))
    parse_score << new_score
    File.write(@filename,parse_score.to_json)
  end

  def print_scores
    scores = parse_scores
    scores_table(scores)
    print welcome.blue
  end

  def scores_table(scores)
    table = Terminal::Table.new
    table.title = "Top Scores".blue.bold
    table.headings = ["Name".blue.italic,"Score".blue.italic]
    score = []
    scores.each do |scor|
      score << [scor[:name].capitalize,scor[:score]]
    end
    score_sort = score.sort_by {|score| -score[1].to_i}
    table.rows = score_sort
    table.style = {
      border_i: '+',
      padding_left: 3,
      padding_right: 3
    }
    table.align_column(2, :right)
    puts table
  end
end
