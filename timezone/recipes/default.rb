#
# Cookbook Name:: timezone
# Recipe:: default
#
# Copyright 2010, James Harton <james@sociable.co.nz>
#
# Apache 2.0 License.
#

if ['debian','ubuntu'].member? node[:platform]
  # Make sure it's installed. It would be a pretty broken system
  # that didn't have it.
  package "tzdata"

  link "/etc/localtime" do
    owner 'root'
    group 'root'
    mode 0644
    filename = "/usr/share/zoneinfo/#{node[:tz]}"
    to filename
    only_if do
      check =  File.exists? filename
      raise "timezone #{node[:tz]} does not exist" unless check
      check
    end
    notifies :run, 'bash[dpkg-reconfigure tzdata]'
  end

  bash 'dpkg-reconfigure tzdata' do
    user 'root'
    code "/usr/sbin/dpkg-reconfigure -f noninteractive tzdata"
    action :nothing
  end

end
