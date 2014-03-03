=begin rdoc
== Brief
Tests for Primo brief results page.

=end
require File.expand_path("#{File.dirname(__FILE__)}/../test_case")
module NyuLibraries::Primo::Contains
  # Test 'contains' search for successful search, common elements, facets and results.
  def test_contains
    @current_test_name = "Primo - Testing Brief Results Display (Contains Search)"
    each_driver do
      each_view_contains_search do |search_term|
        # Set the precision to 'contains'
        set_precision "contains"
        # Search Primo
        submit_search search_term
        # Assert the page title contains the search term
        assert_equal("BobCat - #{search_term}", @driver.title, "Title of 'contains' search page is unexpected for view #{@view} and tab #{@tab}.")
        # Make sure the common elements are there
        common_elements?
        # Check that facets are present
        facets?
        # Check that results are present
        results?
      end
    end
  end
end

class PrimoTest < NyuLibraries::Primo::TestCase
  # include NyuLibraries::Primo::Contains
end