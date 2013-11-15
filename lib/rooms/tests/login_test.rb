=begin rdoc
== Home
Tests for TseTse home page.

=end
require File.expand_path("#{File.dirname(__FILE__)}/../test_case")
module NyuLibraries::Rooms::Login
  # Make sure redirects from root BobCat url go to the correct view
  def test_login
    @current_test_name = "Rooms - Testing login"
    for_all_nyu_users do |user|
      for_each_view do
        login_for_nyu user do
          wait_for_generate_grid
          logged_in?
          assert header?
          assert nav1?
          assert room_reservation_which_date?
          assert reservation_hour?
          assert reservation_minute?
          assert reservation_ampm?
          assert reservation_how_long?
          assert generate_grid?
          assert sidebar?
          assert_equal("Reserve a room", page_title)
        end
      end
    end
  end
end

class RoomsTest < NyuLibraries::Rooms::TestCase
  # include NyuLibraries::Rooms::Login
end