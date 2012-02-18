describe Strip::Version do
  [:Major, :Minor, :Patch].each do |const|
    it "should have #{const} part constant" do
      Strip::Version.constants.should include(const)
    end
  end
end
