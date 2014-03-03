=begin rdoc
== Brief
Tests for Primo brief results page.

=end
require File.expand_path("#{File.dirname(__FILE__)}/../test_case")
module NyuLibraries::Primo::Brief
  # Test default search settings for successful search, common elements, facets and results.
  def test_brief
    @current_test_name = "Primo - Testing Brief Results Display (Default Precision Operator Search)"
    each_driver do
      each_view_default_precision_search do |search_term|
        # Search Primo
        submit_search search_term
        # Assert the page title contains the search term
        assert_equal("BobCat - #{search_term}", @driver.title, "Title of default search page is unexpected for view #{@view} and tab #{@tab}.")
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
  # include NyuLibraries::Primo::Brief
end