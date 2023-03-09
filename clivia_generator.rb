# do not forget to require your gem dependencies
# do not forget to require_relative your local dependencies
require "json"
require "httparty"
require "terminal-table"
class CliviaGenerator
  include HTTParty
  base_uri("https://opentdb.com/api.php?amount=10&")
  # maybe we need to include a couple of modules?

  def initialize
    # we need to initialize a couple of properties here
  end

  def start
    puts welcome
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
    load_questions
    # load the questions from the api
    # questions are loaded, then let's ask them
  end

  def ask_questions
    # ask each question
    # if response is correct, put a correct message and increase score
    # if response is incorrect, put an incorrect message, and which was the correct answer
    # once the questions end, show user's score and promp to save it
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
    p token
    pp response

    # token=YOURTOKENHERE


  end
  def get_token
    response = self.class.get("https://opentdb.com/api_token.php?command=request")
    response = JSON.parse(response.body, symbolize_names:true)
    response[:token]
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