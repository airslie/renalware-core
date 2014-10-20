php_dir = 'php/renalware'
php_host = 'localhost'

php_port = '8001'
pid_file = 'tmp/php.pid'

puts "Starting PHP server on http://#{php_host}:#{php_port}\n\n"

# Create log file
FileUtils.mkdir_p 'log'

# Start PHP and write the process ID to a file
php_env = { 'PHP_ENV' => 'test'}
opts = {
  [:out, :err] => ["log/php_test.log", "a"],
  :chdir => Dir.pwd,
  :pgroup => true
}
cmd = "php -S #{php_host}:#{php_port} -d variables_order=EGPCS -t #{php_dir}"
pid = spawn(php_env, "sh", "-c", cmd, opts)
File.open(pid_file, 'w') {|f| f.write pid }

# Kill the PHP process and delete the PID file
at_exit do
  pid = File.read(pid_file).chomp.to_i
  gpid = Process.getpgid(pid)
  Process.kill(-15, gpid)
  FileUtils.rm pid_file
end