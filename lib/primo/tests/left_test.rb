=begin rdoc
== Left
Tests for Primo left-achored search.

=end
require File.expand_path("#{File.dirname(__FILE__)}/../test_case")
module NyuLibraries::Primo::Left
  # Tests left-anchored author/creator search results for specific title
  def test_left
    @current_test_name = "Primo - Testing Left-Anchored Author Search for Case-Sensitivity?"
    each_driver do
      each_view_default_precision_search do |search_term|
        break unless (@view.eql? "NYU" and @tab.eql? "all")
        # Set precision
        set_precision "exact"
        set_scope1 "creator"
        # Search Primo
        submit_search "Lincoln, Abraham"
        # Need to add step to Click on FRBR-group link
        # Click first link
        click_details_link 1
        # Make sure the common elements are there
        common_elements?
        # sleep 5
        assert_equal("Douglas an enemy to the North reasons why the North should oppose Judge Douglas : speech of Hon. Abraham Lincoln, of Illinois, delivered at Cincinnati, September 19, 1859.", record_title, "Bummer. No match")
        
      end
    end
  end
end