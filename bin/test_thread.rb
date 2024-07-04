#!/usr/bin/env -S ruby -I lib -w
# frozen_string_literal: true

require_relative 'lib/net/gemini'

all_threads = []

100.times do
  all_threads << Thread.new(ARGV[0]) do |arg|
    response = Net::Gemini.get_response URI(arg)
    puts "#{response.status} - #{response.meta}"
  end
end

sleep 0.5 while Thread.list.length > 1
