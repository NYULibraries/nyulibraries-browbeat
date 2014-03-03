=begin rdoc
== Brief
Tests for Primo brief results page.

=end
require File.expand_path("#{File.dirname(__FILE__)}/../test_case")
module NyuLibraries::Primo::ExactTitle
  # Test 'exact' search with scope limited to title for successful search, common elements, facets, results and accuracy of results.
  def test_exact_title
    @current_test_name = "Primo - Testing Brief Results Display (Exact Title Search)"
    each_driver do
      each_view_exact_search do |search_term|
        # Set the precision to 'exact'
        set_precision "exact"
        # Set scope 1 to title
        set_scope1 "title"
        # Search Primo
        submit_search search_term
        # Assert the page title contains the search term
        assert_equal("BobCat - #{search_term}", @driver.title, "Title of 'exact' search page is unexpected for view #{@view} and tab #{@tab}.")
        # Make sure the common elements are there
        common_elements?
        # Check that facets are present
        facets?
        # Check that results are present
        results?
        # Turned this off, some titles are alternate titles
        # Loop through the primo titles and assert they contain the search term
        # record_titles.each do |title|
        #           assert_not_nil(title.downcase.match(search_term), "Primo title '#{title}' doesn't match search term '#{search_term}' for view #{@view} and tab #{@tab}.")
        #         end
        assert_not_nil(record_title.downcase.match(search_term), "Primo title '#{record_title}' doesn't match search term '#{search_term}' for view #{@view} and tab #{@tab}.")
      end
    end
  end
end

class PrimoTest < NyuLibraries::Primo::TestCase
  # include NyuLibraries::Primo::ExactTitle
end