=begin rdoc
== Full
Tests for Arch add to eshelf.

=end
require File.expand_path("#{File.dirname(__FILE__)}/../test_case")
module NyuLibraries::Primo
  module EshelfNumberRecords
    # Make sure redirects from root BobCat url go to the correct view
    def test_add_ten_records_to_eshelf
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
          for i in 0..9
            click_add_to_eshelf i
            wait_for_add_to_eshelf i
          end
          @driver.find_element(:class, "next").click
          click_add_to_eshelf
          wait_for_add_to_eshelf
          click_eshelf_link
          wait_for_eshelf
          assert @driver.find_element(:class, "next_page").displayed?
        end
      end
    end
  end
end

class PrimoTest < NyuLibraries::Primo::TestCase
  # include NyuLibraries::Primo::EshelfNumberRecords
end