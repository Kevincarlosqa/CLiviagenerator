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

trivia = CliviaGenerator.new(filename)
trivia.start
