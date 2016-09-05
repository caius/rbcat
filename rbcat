#!/usr/bin/env ruby

files = ARGV

# Handle no arguments by reading stdin
files[0] ||= "-"

exit_code = 0

files.each do |path|
  if path == "-"
    $stdout.print($stdin.read)
    next
  end

  if File.exist?(path)
    $stdout.print(File.read(path))
  else
    $stderr.puts "cat: #{path}: No such file or directory"
    exit_code = 1
  end

  $stdout.flush
end

exit(exit_code)
