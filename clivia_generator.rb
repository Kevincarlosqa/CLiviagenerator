# do not forget to require your gem dependencies
# do not forget to require_relative your local dependencies

class CliviaGenerator
  # maybe we need to include a couple of modules?

  def initialize
    # we need to initialize a couple of properties here
  end

  def start
    # welcome message
    puts welcome
    action = menu
    p action
    case action
    when "random"
    when "scores"
    when "exit"
    end
    # prompt the user for an action
    # keep going until the user types exit
  end

  def random_trivia
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
    # ask the api for a random set of questions
    # then parse the questions
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

  def menu
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

  # def error_message(input)
    
  #   loop do
  #     input = gets.chomp
     
  #     break if opciones.include?(input)
  #   end
  #   input
  # end

end

neu = CliviaGenerator.new
neu.start