# do not forget to require your gem dependencies
# do not forget to require_relative your local dependencies
require "json"
require "httparty"
require "terminal-table"
require "htmlentities"
require "colorize"

class CliviaGenerator
  include HTTParty
  base_uri("https://opentdb.com/api.php?amount=10&")
  # maybe we need to include a couple of modules?

  def initialize(filename)
    @filename = filename
    p @filename
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
    # load the questions from the api
    # questions are loaded, then let's ask them
  end
  def menu_options
    puts "random | scores | exit"
    opciones = ["random", "scores", "exit"]
    opcion = " "
    loop do
      print "> "
      opcion = gets.chomp
      break if opcion.nil? || opciones.include?(opcion)
      puts "Invalid Option"
    end
    opcion
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
    # print the scores sorted from top to bottom
    scores = parse_scores
    scores_table(scores)
    print welcome.blue
    
  end

  def ask_questions(data)
      puts "Category: #{data[:category]} | Difficulty: #{data[:difficulty]}".colorize(:blue).bold
      question = decode(data[:question])
      puts "Question: #{question}".bold
      answers = []
      correct_answer = decode(data[:correct_answer])
      answers << correct_answer
      decode_options(data[:incorrect_answers]).each {|ans| answers << ans}
      answers.shuffle!.each_with_index do|answer,index|
        puts "#{index+1}. #{answer}"
      end
      compare_answer(answers, correct_answer) 
  end
  def ask_safe_score
    puts "Do you want to save your score? (y/n)"
    print "> "
    input = ""
    loop do
      input = gets.chomp.upcase
      break if input == "Y" || input == "N"
      puts "Invalid option"
      print "> "
    end
    input
  end

  def parse_scores
    res = JSON.parse(File.read(@filename), symbolize_names:true)
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
  def load_questions
    token = get_token
    response = self.class.get("/token=#{token}")
    response = JSON.parse(response.body, symbolize_names:true)
    response[:results]
  end
  def get_token
    response = self.class.get("https://opentdb.com/api_token.php?command=request")
    response = JSON.parse(response.body, symbolize_names:true)
    response[:token]
  end

  def decode(string)
    decoder = HTMLEntities.new
    decoder.decode(string)
  end

  def decode_options(options)
    decoder = HTMLEntities.new
    options.map do |option|
      decoder.decode(option)
    end
  end

  def compare_answer(answers, correct_answer)
    print "> "
    input = gets.chomp.to_i
    chosen_answer = answers[input-1]
    if chosen_answer == correct_answer
      puts "\u2713 #{chosen_answer}... Correct!".green
      puts "-"*60
      true
    else
      puts "\u2717 #{chosen_answer}... Incorrect!".red
      puts "The correct answer was: #{correct_answer}"
      puts "-"*60
      false
    end
  end
  
  def welcome
    wel = "Welcome to Clivia Generator".bold
    welcome =<<-DELIMETER
###################################
#   #{wel}   #
###################################
DELIMETER
  end

  
end

# neu = CliviaGenerator.new
# neu.start
# trivia = CliviaGenerator.new
# trivia.start