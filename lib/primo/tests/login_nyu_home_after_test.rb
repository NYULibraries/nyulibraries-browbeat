=begin rdoc
== Login
Tests for Primo login functionality.

=end
require File.expand_path("#{File.dirname(__FILE__)}/../test_case")
module NyuLibraries::Primo::LoginNyuHomeAfter
  # Test that login works from home page, brief results and full details.
  # Login should return to the correct pre-login page
  # Logout should return to the login page
  def test_login_from_home_nyu_after_app
    @current_test_name = "Primo - Testing logging in from home after visiting app"
    @private = true
    for_all_nyu_users_search do |user|
      # Save the app's url locally so we can go back
      current_url = @driver.current_url
      login_for_nyu_home user do
        # Go back to the app's url
        @driver.navigate.to "#{current_url}"
        wait_for_search_field 
        assert_nothing_raised "Logged in from NYU Home and stil logged in at view #{@view} and tab #{@tab}." do
          assert_equal("Login", login_text, "On home page login text is unexpected for view #{@view} and tab #{@tab}.")
        end
      end
    end
  end
end

class PrimoTest < NyuLibraries::Primo::TestCase
  # include NyuLibraries::Primo::LoginNyuHomeAfter
end