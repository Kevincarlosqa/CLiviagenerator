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

  def initialize
    # we need to initialize a couple of properties here
  end

  def start
    puts welcome.blue
    action = ""
    until action == "exit"
      action = menu_options
      case action
      when "random" then random_trivia
      when "scores" then print_scores
      when "exit" 
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
    puts "Well done! Your score is #{counter*10}" 
    puts "-"*60
    ask_safe_score
    # load the questions from the api
    # questions are loaded, then let's ask them
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
     
    # ask each question
    # if response is correct, put a correct message and increase score
    # if response is incorrect, put an incorrect message, and which was the correct answer
    # once the questions end, show user's score and promp to save it
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
  def save(data)
    # write to file the scores data
  end

  def parse_scores
    # get the scores data from file
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
      puts "#{chosen_answer}... Correct!".green
      puts "-"*60
      true
    else
      puts "#{chosen_answer}... Incorrect!".red
      puts "The correct answer was: #{correct_answer}"
      puts "-"*60
      false
    end
  end

  def parse_questions
    # questions came with an unexpected structure, clean them to make it usable for our purposes
  end

  def print_scores
    # print the scores sorted from top to bottom
    
  end

  def welcome
    welcome =<<-DELIMETER
###################################
#   Welcome to Clivia Generator   #
###################################
    DELIMETER
  end

  def menu_options
    puts "random | scores | exit"
    opciones = ["random", "scores", "exit"]
    loop do
      print "> "
      opcion = gets.chomp
      return opcion if opcion.nil? || opciones.include?(opcion)
      puts "Invalid Option"
    end
    opcion
  end
end

neu = CliviaGenerator.new
neu.start