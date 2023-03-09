require_relative "clivia_generator"
require "json"
first, *rest = ARGV
if first.nil?
  filename = "scores.json"
else
  # filename = first
  data = []
# begin
  File.write(first, JSON.generate(data))
  filename = first
# rescue Errno::ENOENT => error
#   puts error.message
# end
end
p filename


trivia = CliviaGenerator.new(filename)
trivia.start