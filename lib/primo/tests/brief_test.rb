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
  
  # This test verify sorting by checking the appropriate sort values in the PNX record.  
  # This is NOT ideal. The more correct approach is to look at the values as presented on
  # the brief results screen and determine whether the list is sorted by the appropriate 
  # value.  This is DIFFICULT given the discrepancy between the display of an element and
  # the actual way it is sorted, e.g. author is displayed 'first_name last_name' but sorted
  # 'last_name, first_name'
  def test_sort
    skip("'This sorting test sucks anyway.'")
    @current_test_name = "Primo - Testing Brief Results Sort (Default Precision Operator Search)"
    each_driver do
      each_view_default_precision_search do |search_term|
        submit_search search_term
        each_view_sort do |sort, sort_values|
          # Store values for checking sort order
          sorted_values = []
          # Get results and go to details for each item
          details_urls = []
          details_links.each do |link|
            details_urls << link[:href]
          end
          details_urls.each do |details_url|
            pnx_url = details_url + "&showPnx=true"
            come_back_after do
              @driver.navigate.to pnx_url
              sorted_values << @driver.find_element(:xpath, "//record/sort/#{sort_values["xpath"]}").text
            end
          end       
          auto_sorted = sorted_values.sort
          auto_sorted.reverse! if sort_values["order"].eql?("descending")
          assert(sorted_values == auto_sorted, "Sorted arrays not equal for view #{@view} and tab #{@tab}.")
          @driver.navigate.refresh
        end
      end
    end
  end
end

class PrimoTest < NyuLibraries::Primo::TestCase
  include NyuLibraries::Primo::Brief
end