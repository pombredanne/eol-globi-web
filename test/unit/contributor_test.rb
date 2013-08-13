require 'test_helper'

class ContributorTest < ActiveSupport::TestCase
	test 'fetch contributors' do
		contributors = Contributor.fetch_contributors
		assert contributors.length > 0
    contributors.each do |contributor|
      assert_not_nil contributor.name
      assert_not_nil contributor.institution
      assert_not_nil contributor.timePeriod
      assert_not_nil contributor.studyTitle
    end
	end

end
