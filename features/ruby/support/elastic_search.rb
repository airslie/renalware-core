require 'elasticsearch/extensions/test/cluster'

ELASTIC_SEARCH_TEST_PORT = 9250

Before('@elasticsearch') do
  unless $es_started
    begin
      $es_started = true

      Elasticsearch::Extensions::Test::Cluster.start(
        command: ENV['ELASTIC_SEARCH_BINARY'] || `which elasticsearch`,
        port: ELASTIC_SEARCH_TEST_PORT,
        nodes: 1
      )

      Elasticsearch::Model.client = Elasticsearch::Client.new(host: "localhost:#{ELASTIC_SEARCH_TEST_PORT}")
    rescue Exception => e
      puts "Could not start ElasticSearch: #{e.message}"
      print e.backtrace.join("\n")
    end
  end
end

at_exit do
  if $es_started
    Elasticsearch::Extensions::Test::Cluster.stop(port: ELASTIC_SEARCH_TEST_PORT)
  end
end