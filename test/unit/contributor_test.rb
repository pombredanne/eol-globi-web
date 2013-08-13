require 'test_helper'

class ContributorTest < ActiveSupport::TestCase
	test 'fetch contributors' do
		contributors = Contributor.fetch_contributors
		assert contributors.length > 0
    contributors.each do |contributor|
      assert_not_equal contributor.name, 'null'
      assert_not_equal contributor.institution, 'null'
      assert_not_equal contributor.timePeriod, 'null'
      assert_not_equal contributor.studyTitle, 'null'
    end
	end

end
