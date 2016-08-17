require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/*_test.rb']
end

task :default => :test

desc "Compile all project Ruby files with warnings."
task :compile do 
    paths = Dir["**/*.rb"]
    paths.each do |f|
        puts "\nCompiling #{f}..."
        puts `ruby -cw #{f}`
    end
end
