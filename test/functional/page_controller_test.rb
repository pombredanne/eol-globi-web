require 'test_helper'

class PageControllerTest < ActionController::TestCase

  test 'get data contributors' do
    get :data_contributors
  end

end