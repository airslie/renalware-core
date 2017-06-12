require "csv"
require_relative "./seeds/seeds_helper.rb"

def log(msg, type: :full)
  case type
  when :full
    print "-----> #{msg}"
    if block_given?
      ms = Benchmark.ms { yield }
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


# Seed the database with data common to all installations.
# Site specific data should be seeded from the host application.
require_relative "./seeds/default/seeds.rb"
