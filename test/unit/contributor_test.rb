require 'test_helper'

class ContributorTest < ActiveSupport::TestCase
	test 'fetch contributors' do
		contributors = Contributor.fetch_contributors
		assert contributors.length > 0
	end

end
