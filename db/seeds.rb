# frozen_string_literal: true

require "csv"
require_relative "./seeds/seeds_helper"

def log(msg, type: :full, &block)
  case type
  when :full
    print "-----> #{msg}"
    if block
      ms = Benchmark.ms(&block)
      milliseconds = "#{ms.to_i}ms"
      print "\r-----> #{milliseconds.ljust(8, ' ')} #{msg}"
    end
    print "\n"
  when :sub
    puts "                #{msg}"
  else
    raise "Unknown type #{type}"
  end
end

PaperTrail.enabled = false

# Seed the database with data common to all installations.
# Site specific data should be seeded from the host application.
require_relative "./seeds/default/seeds"

SeedStep.seed_steps.each do |klass|
  log klass.to_s.demodulize.titleize do
    klass.new.call
  end
end
