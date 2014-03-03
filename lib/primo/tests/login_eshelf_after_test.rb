=begin rdoc
== Login
Tests for Primo login functionality.

=end
require File.expand_path("#{File.dirname(__FILE__)}/../test_case")
module NyuLibraries::Primo::LoginEshelfAfter
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
  # include NyuLibraries::Primo::LoginEshelfAfter
end