=begin rdoc
== Home
Tests for TseTse home page.

=end
require File.expand_path("#{File.dirname(__FILE__)}/../test_case")
module NyuLibraries::Rooms::Home
  # Make sure redirects from root BobCat url go to the correct view
  def test_home
    @current_test_name = "Rooms - Testing elements"
    each_driver do
      for_each_view do
        is_page_title? "BobCat"
      end
    end
  end
end

class RoomsTest < NyuLibraries::Rooms::TestCase
  # include NyuLibraries::Rooms::Home
end