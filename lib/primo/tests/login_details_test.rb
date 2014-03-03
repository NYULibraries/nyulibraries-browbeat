=begin rdoc
== Login
Tests for Primo login functionality.

=end
require File.expand_path("#{File.dirname(__FILE__)}/../test_case")
module NyuLibraries::Primo::LoginDetails
  # Test that login works from home page, brief results and full details.
  # Login should return to the correct pre-login page
  # Logout should return to the login page  
  def test_login_and_logout_details_records_nyu
    @current_test_name = "Primo - Testing Login from detailed record view in NYU"
    @private = true
    # Login/out from the full details page
    for_all_nyu_users_search do |user, search_term|
      next if views_sans_eshelf.include?(@view)
      wait_for_search_field
      # Search Primo
      submit_search search_term
      wait_for_search search_term
      results?
      click_details_link
      no_login_title = @driver.title
      login_for_nyu user do
        logged_in?
        assert_equal(no_login_title, @driver.title, "After login from details page, page title is different from before login for view #{@view} and tab #{@tab}.")
      end
    end
  end
end

class PrimoTest < NyuLibraries::Primo::TestCase
  # include NyuLibraries::Primo::LoginDetails
end