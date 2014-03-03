=begin rdoc
== Login
Tests for Primo login functionality.

=end
require File.expand_path("#{File.dirname(__FILE__)}/../test_case")
module NyuLibraries::Primo::LoginEshelfBefore
  # Test that login works from home page, brief results and full details.
  # Login should return to the correct pre-login page
  # Logout should return to the login page    
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
end

class PrimoTest < NyuLibraries::Primo::TestCase
  # include NyuLibraries::Primo::LoginEshelfBefore
end