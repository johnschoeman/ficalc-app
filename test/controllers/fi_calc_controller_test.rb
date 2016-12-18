require 'test_helper'

class FiCalcControllerTest < ActionDispatch::IntegrationTest
  test "should get timetofi" do
    get fi_calc_timetofi_url
    assert_response :success
  end

end
