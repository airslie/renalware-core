require 'frog_spawn'

ENV['PHP_ENV'] = 'test'
ENV['root_dir'] = 'php/renalware'
ENV['port'] = '8001'

FrogSpawn::Server.start

at_exit do
  FrogSpawn::Server.stop
end