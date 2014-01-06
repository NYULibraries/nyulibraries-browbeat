=begin rdoc
== Home
Tests for GetIt search page.

=end
require File.expand_path("#{File.dirname(__FILE__)}/../test_case")
module NyuLibraries::GetIt::Search
  # Make sure redirects from root BobCat url go to the correct view
  def test_title_contains_search
    @current_test_name = "GetIt - Testing Title Contains Search"
    each_driver do
      for_each_view do
        for_each_default_precision_title_search do |search_term|
          results?
        end
      end
    end
  end
  
  def test_title_exact_search
    @current_test_name = "GetIt - Testing Title Exact Search"
    each_driver do
      for_each_view do
        each_view_exact_search do |search_term|
          results?
        end
      end
    end
  end
end

class GetItTest < NyuLibraries::GetIt::TestCase
  include NyuLibraries::GetIt::Search
end