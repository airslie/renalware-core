# frozen_string_literal: true

module SeedsHelper
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

  def without_papertrail_versioning_for(klasses)
    Array(klasses).each do |klass|
      klass.paper_trail.disable if klass.paper_trail.respond_to?(:disable)
    end

    yield

    Array(klasses).each do |klass|
      klass.paper_trail.enable if klass.paper_trail.respond_to?(:enable)
    end
  end
end
