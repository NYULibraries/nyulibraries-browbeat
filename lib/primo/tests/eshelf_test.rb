=begin rdoc
== Full
Tests for Arch add to eshelf.

=end
require File.expand_path("#{File.dirname(__FILE__)}/../test_case")
module NyuLibraries::Primo
  module Eshelf
    # Make sure redirects from root BobCat url go to the correct view
    def test_add_to_and_remove_from_eshelf
      @current_test_name = "Primo - Testing adding to eshelf THEN REMOVING"
      each_driver do
        each_view_default_precision_search do |search_term|
          # Some views don't have a login, so we skip them.
          next if views_sans_eshelf.include?(@view)
          # Wait for the page to render
          wait_for_search_field
          # Search for a term
          submit_search search_term
          # Wait for search to load
          wait_for_search search_term
          # Store first result title
          results?
          p_title = record_title
          # Otherwise we check to see if the checkbox works.
          if (@driver.capabilities.browser_name.eql?("internet explorer") && @driver.capabilities.version.to_i < 10)
            assert !add_to_eshelf_checkboxes.first.displayed?
          else
            # Add first result to eshelf
            click_add_to_eshelf
            # Wait for it to add.
            wait_for_add_to_eshelf
            come_back_after do
              # Go to e-Shelf
              click_eshelf_link
              wait_for_eshelf
              # Store first record in eshelf's title
              e_title = eshelf_title
              # assert they are the same
              assert_equal(p_title, e_title, "Eshelf does not contain primo record for url #{@driver.current_url} view #{@view} and tab #{@tab}.")
            end
            assert(add_to_eshelf_checkbox.selected?, "Add to eshelf is unexpectedly unchecked for view #{@view} and tab #{@tab}.")
            click_add_to_eshelf
            wait_for_uncheck_add_to_eshelf
            click_eshelf_link
            wait_for_eshelf
            assert_equal(nil, eshelf_title, "Primo title is the same as eshelf title after removal add for view #{@view} and tab #{@tab}.")
          end
        end
      end
    end
  end
end

class PrimoTest < NyuLibraries::Primo::TestCase
  # include NyuLibraries::Primo::Eshelf
end