=begin rdoc
== Brief
Tests for Primo brief results page.

=end
require File.expand_path("#{File.dirname(__FILE__)}/../test_case")
module NyuLibraries::Primo::StartsWith
  # Test 'starts with' search for successful search, common elements, facets, results and accuracy of results.
  def test_starts_with
    @current_test_name = "Primo - Testing Brief Results Display (Starts With Title Search)"
    each_driver do
      each_view_starts_with_search do |search_term|
        # Set the precision to 'begins_with'
        set_precision "begins_with"
        # Search Primo
        submit_search search_term
        # Assert the page title contains the search term
        assert_equal("BobCat - #{search_term}", @driver.title, "Title of 'starts with' search page is unexpected for view #{@view} and tab #{@tab}.")
        # Make sure the common elements are there
        common_elements?
        # Check that facets are present
        facets?
        # Check that results are present
        results?
        # Loop through the primo titles and assert they start with the search term (with an optional 'the')
        record_titles.each do |title|
          assert_not_nil(title.downcase.match(Regexp.new("^((the|a) )?#{search_term}")), "Primo title '#{title}' doesn't start with search term '#{search_term}' for view #{@view} and tab #{@tab}.")
        end
      end
    end
  end
end

class PrimoTest < NyuLibraries::Primo::TestCase
  include NyuLibraries::Primo::StartsWith
end