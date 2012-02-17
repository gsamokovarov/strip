module Strip::Version
  Major, Minor, Patch =
    File.read(File.expand_path('../../../version.txt', __FILE__)).split('.')
end
