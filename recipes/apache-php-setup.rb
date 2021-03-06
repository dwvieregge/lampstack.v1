## apache and php setup

package 'httpd' do
  action :install
end

execute "php-install" do
  command "sudo amazon-linux-extras install -y php7.2"
  action :run
end

#package "php71" do
# action :install
#end

#package "php-pear" do
#  action :install
#end

#package "php-mysql" do
#  action :install
#end

%w[ /etc/php /etc/php/7.1 /etc/php/7.1/cli ].each do |path|
  ##not_if { ::File.exist?("/etc/php/7.1/cli/php.ini") }
  directory path do
    owner 'root'
    group 'root'
    mode '0755'
  end
end

cookbook_file "/etc/php/7.1/cli/php.ini" do
  source "php.ini"
  mode "0644"
  notifies :run, "execute[httpd-restart]"
end

execute "chownlog" do
  command "chown ec2-user /var/log/php"
  action :nothing
end

directory "/var/log/php" do
  action :create
  notifies :run, "execute[chownlog]"
end

execute "httpd-restart" do
  command "sudo /sbin/httpd -k restart"
  action :run
end