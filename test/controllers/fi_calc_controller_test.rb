require 'test_helper'

class FiCalcControllerTest < ActionDispatch::IntegrationTest

  test "should get root" do
    get root_url
    assert_response :success
  end

  test "should get timetofi" do
    get fi_calc_timetofi_url
    assert_response :success
    assert_select "title", "TimeToFi | FICalc App"
  end

end
