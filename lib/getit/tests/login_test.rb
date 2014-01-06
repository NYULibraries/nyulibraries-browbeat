=begin rdoc
== Home
Tests for GetIt home page.

=end
require File.expand_path("#{File.dirname(__FILE__)}/../test_case")
module NyuLibraries::GetIt::Login
  # Make sure redirects from root BobCat url go to the correct view
  def test_login_and_logout
    @current_test_name = "GetIt - Testing loggin in and out."
    for_all_nyu_users do |user|
      for_each_view do
        login_for_nyu user do
          logged_in_with_proper_user? user
        end
      end
    end
  end
  
  def test_login_from_home_nyu_before_app
    @current_test_name = "GetIt - Testing login status after logging in at NYU Home"
    for_all_nyu_users do |user|
      login_for_nyu_home user do
        for_each_view do
          logged_in_with_proper_user? user
        end
      end
    end
  end
  
  def test_login_from_home_nyu_after_app
    @current_test_name = "GetIt - Testing login status after going to app then logging in at NYU Home"
    assert_nil @driver.manage.cookie_named "_getit_session"
    for_all_nyu_users do |user|
      for_each_view do
        cookie = @driver.manage.cookie_named "_getit_session"
        assert_not_nil cookie
        come_back_after do
          nyu_home_login user[:username], user[:password]
        end
        assert_equal @driver.manage.cookie_named("_getit_session"), cookie
        logged_out?
        nyu_home_logout
      end
    end
  end
end

class GetItTest < NyuLibraries::GetIt::TestCase
  include NyuLibraries::GetIt::Login
end