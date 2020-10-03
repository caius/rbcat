# frozen_string_literal: true

require "socket"
require_relative "./cat/stdin_io"

class Cat
  attr_reader :argv

  def initialize(argv)
    @argv = argv.dup
  end

  def call
    files = argv

    # Handle no arguments by reading stdin
    files[0] ||= "-"

    exit_code = 0

    [$stdout, $stderr].each do |io|
      io.sync = true
      io.flush
    end

    files.each do |path|
      if path != "-" && !File.exist?(path)
        $stderr.puts "cat: #{path}: No such file or directory"
        exit_code = 1
        next
      end

      stream_class = case
      when path == "-"
        StdinIO
      when File.socket?(path)
        UNIXSocket
      else
        File
      end

      stream_class.open(path) do |sock|
        IO.copy_stream(sock, $stdout)
      end
    end

    exit_code
  end
end


