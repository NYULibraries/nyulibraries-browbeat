=begin rdoc
== Full
Tests for Primo full details page.

=end
require File.expand_path("#{File.dirname(__FILE__)}/../test_case")
module NyuLibraries::Primo::Full
  # Test full details page for common elements
  def test_full
    @current_test_name = "Primo - Testing Full Details Display (Default Precision Operator Search)"
    each_driver do
      each_view_default_precision_search do |search_term|
        # Search Primo
        submit_search search_term
        # Click first link
        click_details_link
        # Make sure the common elements are there
        common_elements?
      end
    end
  end
end

class PrimoTest < NyuLibraries::Primo::TestCase
  include NyuLibraries::Primo::Full
end