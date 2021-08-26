# frozen_string_literal: true

require "socket"
require_relative "./cat/stdin_io"

class Cat
  attr_reader :argv

  def initialize(argv)
    self.argv = argv.dup
    @exit_code = 0

    @io = $stdout
    @error_io = $stderr

    [@io, @error_io].each do |io|
      io.sync = true
      io.flush
    end
  end

  def call
    argv.each do |path|
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

  private

  attr_reader :io, :error_io

  def argv=(value)
    @argv = if value.empty?
      # Handle no arguments by reading stdin
      ["-"]
    else
      value
    end
  end

  def fail(path)
    @exit_code = 1
    @error_io
  end
end
