=begin rdoc
== Login
Tests for Arch login functionality.

=end
require File.expand_path("#{File.dirname(__FILE__)}/../test_case")
module NyuLibraries::Arch::Login
  # Test that login works from home page, brief results and full details.
  # Login should return to the correct pre-login page
  # Logout should return to the login page
  def test_login_from_home_nyu_after_app
    @current_test_name = "Arch - Testing logging in from home after visiting app"
    @private = true
    for_all_nyu_users do |user|
      each_view_redirects do
        # Save the app's url locally so we can go back
        current_url = @driver.current_url
        login_for_nyu_home user do
          # Go back to the app's url
          @driver.navigate.to "#{current_url}"
          wait_for_arch 
          assert_nothing_raised "Logged in from NYU Home and stil logged in at view #{@view} and tab #{@tab}." do
            assert_equal("Login", login_text, "On home page login text is unexpected for view #{@view} and tab #{@tab}.")
          end
        end
      end
    end
  end
  
  def test_login_from_home_nyu_before_app
    @current_test_name = "Arch - Testing logging in from home before visiting app"
    @private = true
    for_all_nyu_users do |user|
      login_for_nyu_home user do
        each_view_redirects do
          # Some views don't have a login, so we skip them.
          assert_nothing_raised "Cannot log in from NYU Home for view #{@view} and tab #{@tab}." do
            assert_equal("Log-out #{user[:firstname]}", logout_text, "After login from home page, logout text is unexpected for view #{@view} and tab #{@tab}.")
          end
        end
      end
    end
  end
  
  def test_login_and_logout_nyu
    @current_test_name = "Arch - Testing Login in NYU"
    @private = true
    for_all_nyu_users do |user|
      each_view_redirects do
        next if views_sans_access.include?(@view)
        assert_equal("Login", login_text, "On home page login text is unexpected for view #{@view} and tab #{@tab}.")
        login_for_nyu user do
          wait_for_arch
          assert_equal("Login", login_text, "Cannot view these resources for view #{@view} and tab #{@tab}.") if views_sans_access.include?(@view)
          assert_equal("Log-out #{user[:firstname]}", logout_text, "After login from home page, logout text is unexpected for view #{@view} and tab #{@tab}.")
        end
        assert_equal("NYU Login", @driver.title, "After logout from home page, login text is unexpected for view #{@view} and tab #{@tab}.")
      end
    end
  end
  
  def test_permanant_save_from_logged_out_nyu
    @current_test_name = "Arch - Testing permanent add to eshelf in NYU"
    for_all_nyu_users do |user|
      each_view_default_searches do |search_term|
        next if views_sans_access.include?(@view)
        next if views_sans_eshelf.include?(@view)
        next if !@view.eql?(@campus)
        submit_search search_term
        
        # Store first result title
        results?
        x_title = record_title
        
        # Otherwise we check to see if the checkbox works.
        if (@driver.capabilities.browser_name.eql?("internet explorer") && @driver.capabilities.version.to_i < 10)
          assert !add_to_eshelf_checkboxes.first.displayed?
        else
          # Add first result to eshelf
          click_add_to_eshelf
          wait_for_add_to_eshelf
          come_back_after do
            # Go to e-Shelf
            click_eshelf_link
            wait_for_eshelf
            # Store first record in eshelf's title
            e_title = eshelf_title
            # assert they are the same
            assert_equal(x_title, e_title, "Eshelf does not contain primo record for url #{@driver.current_url} view #{@view} and tab #{@tab}.")
          end
          assert(add_to_eshelf_checkbox.selected?, "Add to eshelf is unexpectedly unchecked for view #{@view} and tab #{@tab}.")
          login_for_nyu user do
            wait_for_add_to_eshelf_checkboxes
            assert(add_to_eshelf_checkbox.selected?, "Add to eshelf is unexpectedly unchecked for view #{@view} and tab #{@tab}.")
            come_back_after do
              # Go to e-Shelf
              click_eshelf_link
              wait_for_eshelf
              # Store first record in eshelf's title
              e_title = eshelf_title
              # assert they are the same
              assert_equal(x_title, e_title, "Eshelf does not contain primo record for url #{@driver.current_url} view #{@view} and tab #{@tab}.")
            end
            click_add_to_eshelf
            wait_for_uncheck_add_to_eshelf
            come_back_after do
              click_eshelf_link
              wait_for_eshelf
              assert_equal(nil, eshelf_title, "Primo title is the same as eshelf title after removal add for view #{@view} and tab #{@tab}.")
            end
          end
        end
      end
    end
  end
  
  def test_search_not_logged_in
    @current_test_name = "Arch - Search when not logged in"
    @private = true
    each_driver do
      each_view_default_searches do |search_term|
        next if @view.eql?(@campus)
        submit_search search_term
        assert_equal("BobCat", @driver.title, "Title should be BobCat for not logged in for view #{@view} and tab #{@tab}.")
        assert(login_page?, "Should redirect to login page for view #{@view} and tab #{@tab}.")
      end
    end
  end
end

class ArchTest < NyuLibraries::Arch::TestCase
  include NyuLibraries::Arch::Login
end