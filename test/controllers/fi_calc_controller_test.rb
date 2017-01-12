require 'test_helper'

class FiCalcControllerTest < ActionDispatch::IntegrationTest

  test "should get root" do
    get root_path
    assert_response :success
  end

  test "should get glossary" do
    get glossary_path
    assert_select :success
    assert_select "title", "Glossary | FICalc App"
  end

end
