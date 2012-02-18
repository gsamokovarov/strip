describe Strip::Util do
  [:ExceptionDeclaration, :SubclassRequirements].each do |const|
    it "should have #{const}" do
      Strip::Util.constants.should include(const)
    end
  end

  context 'when extended' do
    it 'should extend the base with ExceptionDeclaration and SubclassRequirements' do
      cls = create(:class) { extend Strip::Util }

      cls.private_methods.should include(:exception)
      cls.private_methods.should include(:require_subclass_to_implement)
    end
  end

  context 'module functions' do
    describe '::constantize' do
      it 'should create a constant friendy name of the given one' do
        Strip::Util.constantize('const').should       eq('Const')
        Strip::Util.constantize('dash-split').should  eq('DashSplit')
        Strip::Util.constantize('under_score').should eq('UnderScore')
      end
    end
  end
end
