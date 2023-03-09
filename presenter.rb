module Presenter

  def welcome
    wel = "Welcome to Clivia Generator".bold
    welcome =<<-DELIMETER
###################################
#   #{wel}   #
###################################
DELIMETER
  end

  def menu_options
    puts "random | scores | exit"
    opciones = ["random", "scores", "exit"]
    opcion = " "
    loop do
      print "> "
      opcion = gets.chomp
      break if opciones.include?(opcion)
      puts "Invalid Option"
    end
    opcion
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

  def print_score(score)
    # print the score message
  end
end
