require_relative "clivia_generator"
require "json"
first, *rest = ARGV
if first.nil?
  filename = "scores.json"
else
  data = []
begin
  filename = File.write(first, JSON.generate(data))
rescue Errno::ENOENT => error
  puts error.message
end
end
p filename


trivia = CliviaGenerator.new(filename)
trivia.start