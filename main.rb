require_relative "clivia_generator"

first, *rest = ARGV
puts first
begin
acores = JSON.parse(File.read(first)) if first
rescue Errno::ENOENT => error
  puts error.message
end
p acores
trivia = CliviaGenerator.new
trivia.start