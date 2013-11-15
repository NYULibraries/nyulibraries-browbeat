=begin rdoc
== Login
Tests for Primo login functionality.

=end
require File.expand_path("#{File.dirname(__FILE__)}/../test_case")
module NyuLibraries::Primo::Login
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
  
  def test_login_and_logout_nyu
    @current_test_name = "Primo - Testing Login and logout NYU"
    @private = true
    for_all_nyu_users_search do |user|
      wait_for_search_field
      # Login/out from home page.
      assert_equal("Login", login_text, "On home page login text is unexpected for view #{@view} and tab #{@tab}.")
      login_for_nyu user do
        assert_equal("Log-out #{user[:firstname]}", logout_text, "After login from home page, logout text is unexpected for view #{@view} and tab #{@tab}.")
      end
      assert_equal("NYU Login", @driver.title, "After logout from home page, login text is unexpected for view #{@view} and tab #{@tab}.")
    end
  end
  
  def test_login_and_logout_brief_records_nyu
    @current_test_name = "Primo - Testing Login from brief records in NYU"
    @private = true
    # Login/out from the brief details page
    for_all_nyu_users_search do |user, search_term|
      next if views_sans_eshelf.include?(@view)
      wait_for_search_field
      # Search Primo
      submit_search search_term
      wait_for_search search_term
      results?
      no_login_title = record_title
      login_for_nyu user do
        logged_in?
        assert_equal(no_login_title, record_title, "After login from search page, item title is different from before login for view #{@view} and tab #{@tab}.")
      end
    end
  end
  
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
  
  def test_permanant_save_and_delete_from_logged_in_nyu
    @current_test_name = "Primo - Testing adding and deleting to eshelf when logged in"
    @private = true
    for_all_nyu_users_search do |user, search_term|
      next if views_sans_eshelf.include?(@view)
      login_for_nyu user do
        assert_equal("Log-out #{user[:firstname]}", logout_text, "After login from home page, logout text is unexpected for view #{@view} and tab #{@tab}.")
        wait_for_search_field
        submit_search search_term
        results?
        p_title = record_title
        if !add_to_eshelf_checkbox.selected?
          click_add_to_eshelf
          wait_for_add_to_eshelf
          come_back_after do
            click_eshelf_link
            wait_for_eshelf
            e_title = eshelf_title
            assert_equal(p_title, e_title, "Primo title is not the same as eshelf title after add for view #{@view} and tab #{@tab}.")
          end
          wait_for_search_field
          results?
          assert(add_to_eshelf_checkbox.selected?, "Add to eshelf is unexpectedly unchecked for view #{@view} and tab #{@tab}.")
        end
        click_add_to_eshelf
        wait_for_uncheck_add_to_eshelf
        come_back_after do
          click_eshelf_link
          wait_for_eshelf
          e_title = eshelf_title
          assert_not_equal(p_title, e_title, "Primo title is the same as eshelf title after removal add for view #{@view} and tab #{@tab}.")
        end
        assert((not add_to_eshelf_checkbox.selected?), "Add to eshelf is unexpectedly checked for view #{@view} and tab #{@tab}.")
      end
    end
  end
  
  def test_permanant_save_from_logged_out_nyu
    @current_test_name = "Primo - Testing adding and deleting to eshelf when logged in after adding to eshelf"
    @private = true
    for_all_nyu_users_search do |user, search_term|
      next if views_sans_eshelf.include?(@view)
      wait_for_search_field
      submit_search search_term
      results?
      assert((not add_to_eshelf_checkbox.selected?), "Add to eshelf is unexpectedly checked for view #{@view} and tab #{@tab}.")
      click_add_to_eshelf if !add_to_eshelf_checkbox.selected?
      wait_for_add_to_eshelf
      p_title = record_title
      login_for_nyu user do
        logged_in?
        p_title = record_title
        come_back_after do
          click_eshelf_link
          wait_for_eshelf
          e_title = eshelf_title
          assert_equal(p_title, e_title, "Primo title is not the same as eshelf title after add for view #{@view} and tab #{@tab}.")
        end
        assert(add_to_eshelf_checkbox.selected?, "Add to eshelf is unexpectedly unchecked for view #{@view} and tab #{@tab}.")
        click_add_to_eshelf
        wait_for_uncheck_add_to_eshelf
        come_back_after do
          click_eshelf_link
          wait_for_eshelf
          e_title = eshelf_title
          assert_not_equal(p_title, e_title, "Primo title is the same as eshelf title after removal add for view #{@view} and tab #{@tab}.")
        end
        assert(!add_to_eshelf_checkbox.selected?, "Primo title not in eshelf showing that it is for view #{@view} and tab #{@tab}.")
      end
    end
  end
end

class PrimoTest < NyuLibraries::Primo::TestCase
  # include NyuLibraries::Primo::Login
end