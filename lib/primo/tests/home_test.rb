=begin rdoc
== Home
Tests for Primo home page.

=end
require File.expand_path("#{File.dirname(__FILE__)}/../test_case")
module NyuLibraries::Primo::Home
  # Test home page for common elements
  def test_home
    @current_test_name = "Primo - Testing Home Page"
    each_driver do
      each_view_tab do
        # Make sure the common elements are there
        common_elements?
      end
    end
  end
end

class PrimoTest < NyuLibraries::Primo::TestCase
  # include NyuLibraries::Primo::Home
end