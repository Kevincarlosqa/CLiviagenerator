module Handler
  def getting_token
    response = self.class.get("https://opentdb.com/api_token.php?command=request")
    response = JSON.parse(response.body, symbolize_names: true)
    response[:token]
  end

  def load_questions
    token = getting_token
    response = self.class.get("/token=#{token}")
    response = JSON.parse(response.body, symbolize_names: true)
    response[:results]
  end

  def ask_questions(data)
    puts "Category: #{data[:category]} | Difficulty: #{data[:difficulty]}".colorize(:blue).bold
    question = decode(data[:question])
    puts "Question: #{question}".bold
    answers = []
    correct_answer = decode(data[:correct_answer])
    answers << correct_answer
    decode_options(data[:incorrect_answers]).each { |ans| answers << ans }
    answers.shuffle!.each_with_index do |answer, index|
      puts "#{index + 1}. #{answer}"
    end
    compare_answer(answers, correct_answer)
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
    chosen_answer = answers[input - 1]
    if chosen_answer == correct_answer
      puts "\u2713 #{chosen_answer}... Correct!".green
      puts "-" * 60
      true
    else
      puts "\u2717 #{chosen_answer}... Incorrect!".red
      puts "The correct answer was: #{correct_answer}"
      puts "-" * 60
      false
    end
  end

  def parse_scores
    JSON.parse(File.read(@filename), symbolize_names: true)
  end
end
