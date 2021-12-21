# # TODO: Write documentation for `Dirsplitter`
# module Dirsplitter
#   VERSION = "0.1.0"

#   # TODO: Put your code here
# end
require "option_parser"
require "./*"

split_mode = false
reverse_mode = false
dir = "."
max = 5.0
prefix = ""

parser = OptionParser.new do |parser|
  parser.banner = "Usage: dirsplitter [subcommand] [arguments] [DIRECTORY]"

  parser.on("split", "Splits directories into a specified maximum size") do
    split_mode = true
    parser.banner = "Usage: displitter split [arguments] [FOLDER]"
    parser.on("-d DIRPATH", "--dir=DIRPATH", DIR_DESC) { |_dir| dir = _dir }
    parser.on("-m MAX", "--max=MAX", MAX_DESC) { |_max| max = _max.to_f }
    parser.on("-p PREFIX", "--prefix=PREFIX", PREFIX_DESC) { |pre| prefix = pre }
  end

  parser.on("reverse", REVERSE_DESC) do
    reverse_mode = true
    parser.banner = "Usage: displitter reverse [DIRECTORY]"
    parser.on("-d DIRPATH", "--dir=DIRPATH", DIR_DESC) { |_dir| dir = _dir }
  end

  parser.on("-h", "--help", "Show this help") do
    puts parser
    exit
  end

  parser.invalid_option do |flag|
    STDERR.puts "ERROR: #{flag} is not a valid option."
    STDERR.puts parser
    exit(1)
  end
end

parser.parse

if split_mode
  split_dir(dir, (max * GBMULTIPLE).to_u64, prefix)
elsif reverse_mode
  reverse_split(dir)
else
  STDERR.puts "Error parsing args"
  puts parser
  exit(1)
end
