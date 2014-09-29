php_host = 'localhost'
php_port = 8000
pid_file = 'tmp/php.pid'

puts "Starting PHP server on http://#{php_host}:#{php_port}\n\n"

# Start PHP and write the process ID to a file
pipe = IO.popen "php -S #{php_host}:#{php_port}"
File.open(pid_file, 'w') {|f| f.write pipe.pid }

# Kill the PHP process and delete the PID file
at_exit do
  pid = File.read(pid_file).chomp.to_i
  Process.kill("SIGTERM", pid)
  FileUtils.rm pid_file
end