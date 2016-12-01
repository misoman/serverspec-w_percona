require 'spec_helper'

describe 'w_percona::default' do

	describe command('apt-key list') do
  		its(:stdout) { should match /8507EFA5/ }
	end

	['toolkit', 'xtrabackup', 'xtradb-cluster-56', 'xtradb-cluster-client-5.6', 'xtradb-cluster-common-5.6', 'xtradb-cluster-galera-3', 'xtradb-cluster-galera-3.x', 'xtradb-cluster-server-5.6' ].each do |package|
		describe package("percona-#{package}") do
	  	it { should be_installed }
		end
	end

  describe service('mysql') do
    it { should be_enabled }
    it { should be_running }
  end

	#following replication ports excluded for now
	#4444, 4568, 9200
	[3306, 4567].each do |percona_port|
		describe port(percona_port) do
		  it { should be_listening.with('tcp') }
		end
	end

	describe file('/etc/mysql/my.cnf') do
  	it { should be_file }
    its(:content) { should match /vagrant_cluster/ }
    its(:content) { should match /bind-address = 0.0.0.0/ }
	end
end
