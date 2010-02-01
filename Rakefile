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
    s.name = "messager"
    s.summary = "Messager: easy message sending"
    s.email = "brandon@zencoder.tv"
    s.homepage = "http://github.com/zencoder/messager"
    s.description = "Messager: easy message sending"
    s.authors = ["Brandon Arbini"]
    s.files = FileList["[A-Z]*.*", "{lib,test}/**/*"]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install jeweler."
end
