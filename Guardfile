guard :rspec, :cli => '-f doc -r "spec_helper" -c' do
  watch(%r{^lib/(.+)\.rb$})  { 'spec' }
  watch(%r{^spec/(.+)\.rb$}) { 'spec' }
end
