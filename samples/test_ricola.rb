#!/usr/bin/env ruby

require '../lib/rico.rb'

abort "Usage: #{File.basename($0)} <file_to_parse>" unless ARGV.length == 1

Rico::Ricola.parse_file(ARGV[0])
