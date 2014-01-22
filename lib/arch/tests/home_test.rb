=begin rdoc
== Home
Tests for Arch home page.

=end
require File.expand_path("#{File.dirname(__FILE__)}/../test_case")
module NyuLibraries::Arch::Home
  # Make sure redirects from root BobCat url go to the correct view
  def test_redirects
    @current_test_name = "Arch - Testing Redirects"
    each_driver do
      each_view_redirects do |redirect|
        assert_not_nil(@driver.current_url.match redirect)
      end
    end
  end

  # Test home page for common elements
  def test_home
    @current_test_name = "Arch - Testing Home Page"
    each_driver do
      each_view_redirects do
        common_elements?
      end
    end
  end
end

class ArchTest < NyuLibraries::Arch::TestCase
  # include NyuLibraries::Arch::Home
end