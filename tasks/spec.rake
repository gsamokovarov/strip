require 'rspec/core/rake_task'

desc 'Run the specifiaction examples'
RSpec::Core::RakeTask.new do |task|
  task.rspec_opts = %w{-r "spec_helper" --color --format documentation}
  task.pattern = FileList['spec/**/*_spec.rb']
end
