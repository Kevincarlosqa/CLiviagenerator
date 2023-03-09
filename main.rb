require_relative "clivia_generator"
require "json"
dato1, dato2 = ARGV
ARGV.clear
# p dato1
if dato1.nil?
  filename = "scores.json"
else
  # filename = dato1
  data = []
# begin
  File.write(dato1, JSON.generate(data))
  filename = dato1
# rescue Errno::ENOENT => error
#   puts error.message
# end
end
# if ARGV.empty?
#   filename = "scores.json"
# else
#   first, *rest = ARGV
#   data = []
#   File.write(first, JSON.generate(data))
#   filename = first
# end
# p filename


trivia = CliviaGenerator.new(filename)
trivia.start