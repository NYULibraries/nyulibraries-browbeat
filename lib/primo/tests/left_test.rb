=begin rdoc
== Left
Tests for Primo default fix 16086, 'starts with' (left-achored), case-sensitive search.

=end
require File.expand_path("#{File.dirname(__FILE__)}/../test_case")
module NyuLibraries::Primo::Left
  # Tests 'starts with' proper-case title search for results
  def test_left
    @current_test_name = "Primo - Testing Left-Anchored Title Search for Case-Sensitivity"
    each_driver do
      each_view_default_precision_search do |search_term|
        break unless (@view.eql? "NYU" and @tab.eql? "all")
        # Set precision
        set_precision "begins_with"
        set_scope1 "title"
        # Search Primo
        submit_search "McCarthy era blacklisting of school teachers"
        # Click first link
        click_details_link 1
        # Make sure the common elements are there
        common_elements?
        # sleep 5
        assert_equal("McCarthy era blacklisting of school teachers, college professors, and other public employees [microform] : the FBI responsibilities program file and the dissemination of information policy file", record_title, "Bummer. No match")
        
      end
    end
  end
end
