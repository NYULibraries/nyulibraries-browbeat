=begin rdoc
== Login
Tests for Primo login functionality.

=end
require File.expand_path("#{File.dirname(__FILE__)}/../test_case")
module NyuLibraries::Primo::LoginBeforeNyuHome    
  def test_login_from_home_nyu_before_app
    @current_test_name = "Primo - Testing logging in from home before visiting app"
    @private = true
    for_all_nyu_users do |user|
      login_for_nyu_home user do
        each_view_tab do
          # Some views don't have a login, so we skip them.
          next if views_sans_login.include?(@view)
          assert_nothing_raised "Cannot log in from NYU Home for view #{@view} and tab #{@tab}." do
            assert_equal("Log-out #{user[:firstname]}", logout_text, "After login from home page, logout text is unexpected for view #{@view} and tab #{@tab}.")
          end
        end
      end
    end
  end
end

class PrimoTest < NyuLibraries::Primo::TestCase
  include NyuLibraries::Primo::LoginBeforeNyuHome
end