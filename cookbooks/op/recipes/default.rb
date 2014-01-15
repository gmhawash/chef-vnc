# install packages

package 'build-essential'
package 'git-core'
package 'curl'
package 'wget'
package 'openssl'
package 'libssl-dev'
package 'libopenssl-ruby'
package 'ruby-dev'
package 'libxml2'
package 'libxml2-dev'
package 'libxslt1-dev'
package 'ruby-libxml'
package 'libffi-dev'
package 'libpgsql-ruby'
package 'libpq-dev'
package 'nginx'


# install ack
package 'ack-grep'
execute 'ln -sf /usr/bin/ack-grep /usr/bin/ack'

#install ruby-shadow - needed to set user password on the 'user' node
# ref: http://docs.opscode.com/resource_user.html
package 'libshadow-ruby1.8'
execute 'gem install ruby-shadow'

package 'vnc4server'
package 'firefox'
package 'xorg'
package 'gdm'
package 'gnome-session'

# setup postgresql 9.3
file '/etc/apt/sources.list.d/pgdg.list' do
  content 'deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main'
  action :create
end

execute 'wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -'
execute 'apt-get update'
execute 'yes | apt-get install postgresql-9.3 postgresql-common postgresql-contrib'

user 'mmh' do
  action :create
  username 'mmh'
  password '$1$5wFLHaE6$3G3NqMTMeYNRVmqF.IoUo0'
  shell '/bin/bash'
  home '/home/mmh'
  system true
  supports :manage_home => true
end

execute 'adduser mmh sudo'

#install ruby-build and chruby
directory '/root/tmp' do
  action :create
end

execute 'get chruby' do
  cwd '/root/tmp'
  command <<-EOH
    rm -rf chruby*
    wget -O chruby-0.3.8.tar.gz https://github.com/postmodern/chruby/archive/v0.3.8.tar.gz
    tar -xzvf chruby-0.3.8.tar.gz
  EOH
end

execute 'install chruby' do
  cwd '/root/tmp/chruby-0.3.8'
  command 'make install'
end

execute 'install ruby-build' do
  cwd '/root/tmp'
  command <<-EOH
    rm -rf ruby-build*
    git clone https://github.com/sstephenson/ruby-build.git
    cd ruby-build
    ./install.sh
  EOH
end


