require 'rubygems'
gem 'rspec', '>=1.1.3'
require 'spec'
require 'pathname'

SPEC_ROOT = Pathname(__FILE__).dirname.expand_path
require SPEC_ROOT.parent + 'lib/dm-core'

# setup mock testing adapter
DataMapper.setup(:default, :adapter => :in_memory)

# These environment variables will override the default connection string:
#   MYSQL_SPEC_URI
#   POSTGRES_SPEC_URI
#   SQLITE3_SPEC_URI
#
# For example, in the bash shell, you might use:
#   export MYSQL_SPEC_URI="mysql://localhost/dm_core_test?socket=/opt/local/var/run/mysql5/mysqld.sock"
#
def setup_adapter(name, default_uri)
  begin
    DataMapper.setup(name, ENV["#{name.to_s.upcase}_SPEC_URI"] || default_uri)
    Object.const_set('ADAPTER', ENV['ADAPTER'].to_sym) if name.to_s == ENV['ADAPTER']
    true
  rescue Exception => e
    if name.to_s == ENV['ADAPTER']
      Object.const_set('ADAPTER', nil)
    end
    false
  end
end

ENV['ADAPTER'] ||= 'sqlite3'

HAS_DO       = DataMapper::Adapters.const_defined?("DataObjectsAdapter")
HAS_SQLITE3  = setup_adapter(:sqlite3,  'sqlite3::memory:')
HAS_MYSQL    = setup_adapter(:mysql,    'mysql://localhost/dm_core_test')
HAS_POSTGRES = setup_adapter(:postgres, 'postgres://postgres@localhost/dm_core_test')

DataMapper::Logger.new(nil, :debug)

