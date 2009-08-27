require 'rubygems'
require 'rake'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.test_files = FileList['tests/steps/*.rb']
end

1.upto(6) do |i|
  Rake::TestTask.new("step_#{i}") do |t|
    t.test_files = (1..i).map { |j| "tests/steps/test_step_0#{j}.rb" }
  end
end