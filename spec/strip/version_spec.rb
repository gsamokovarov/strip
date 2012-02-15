describe 'Strip.version' do
  it 'should consist of Major, Minor and Patch joined by a dot' do
    [Strip::Version::Major, Strip::Version::Minor, Strip::Version::Patch].join('.').should \
      eq(Strip.version)
  end
end
