rightscale_marker :begin

ruby_block "start cf" do
  block do
    system "/opt/jrun4/bin/jrun start cfusion > /tmp/cf.log 2>&1 "
  end
end

until File.exists?('/tmp/cf.log') && open('/tmp/cf.log') { |f| f.grep(/Server cfusion ready/) }
  x += 1
  sleep(1)
  if x == 1000
    break
  end
end

rightscale_marker :end
