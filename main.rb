require_relative "clivia_generator"
require "json"
file1, _file2 = ARGV
ARGV.clear
directorio = Dir.entries(__dir__)
archivos_json = directorio.select { |direc| direc.end_with?(".json") }
if file1.nil?
  filename = "scores.json"
elsif archivos_json.include?(file1)
  filename = file1
else
  data = []
  File.write(file1, JSON.generate(data))
  filename = file1
end
# begin
# rescue Errno::ENOENT => error
#   puts error.message
# end
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
