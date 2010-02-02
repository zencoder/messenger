require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

task :default => :test
Rake::TestTask.new { |t|
  t.pattern = 'test/test_*.rb'
}

Rake::RDocTask.new do |t|
  t.rdoc_dir = 'doc'
  t.rdoc_files.include('lib/**/*.rb')
  t.options << '--inline-source'
  t.options << '--all'
  t.options << '--line-numbers'
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "messenger"
    s.summary = "Messenger: easy message sending"
    s.email = "brandon@zencoder.tv"
    s.homepage = "http://github.com/zencoder/messenger"
    s.description = "Messenger: easy message sending"
    s.authors = ["Brandon Arbini"]
    s.files = FileList["[A-Z]*.*", "{lib,test}/**/*"]
    s.add_dependency('pony', '>= 0.6')
    s.add_dependency('tmail', '>=1.2.6')
    s.add_dependency('mime-types', '>=1.16')
    s.add_dependency('httparty', '>=0.5.2')
    s.add_dependency('SystemTimer', '>=1.1.3')
  end
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler."
end
