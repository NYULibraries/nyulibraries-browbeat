=begin rdoc
== Home
Tests for Primo home page.

=end
require File.expand_path("#{File.dirname(__FILE__)}/../test_case")
module NyuLibraries::Primo::Redirects
  # Make sure redirects from root BobCat url go to the correct view
  def test_redirects
    @current_test_name = "Primo - Testing Redirects"
    each_driver do
      each_view_redirects do |redirect|
        @driver.navigate.to "#{@bobcat}#{redirect}"
        # Wait for the page to render
        wait_for_search_field
        # Did we redirect to the correct URL?
        assert_not_nil(@driver.current_url.match @view)
      end
    end
  end
end

class PrimoTest < NyuLibraries::Primo::TestCase
  include NyuLibraries::Primo::Redirects
end