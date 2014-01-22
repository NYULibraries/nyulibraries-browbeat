=begin rdoc
== Home
Tests for GetIt home page.

=end
require File.expand_path("#{File.dirname(__FILE__)}/../test_case")
module NyuLibraries::GetIt::Home
  # Make sure redirects from root BobCat url go to the correct view
  # def test_home
  #   @current_test_name = "GetIt - Testing elements"
  #   each_driver do
  #     for_each_view do
  #       is_page_title? "BobCat"
  #       common_elements?
  #     end
  #   end
  # end
  def test_redirects
    @current_test_name = "GetIt - Testing Redirects"
    each_driver do
      for_each_view do
        assert_not_nil(@driver.current_url.downcase.match @view.downcase)
      end
    end
  end
end

class GetItTest < NyuLibraries::GetIt::TestCase
  # include NyuLibraries::GetIt::Home
end