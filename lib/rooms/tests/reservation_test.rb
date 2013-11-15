=begin rdoc
== Home
Tests for TseTse home page.

=end
require File.expand_path("#{File.dirname(__FILE__)}/../test_case")
module NyuLibraries::Rooms::Reservation
  # Make sure redirects from root BobCat url go to the correct view
  def test_reservation
    @current_test_name = "Rooms - Testing reserving and removing room"
    for_all_nyu_users do |user|
      for_each_view do
        login_for_nyu user do
          assert no_reservations?
          wait_for_generate_grid
          room_reservation_which_date.click
          wait_for_element_by_class "ui-datepicker-today"
          pick_today.click
          generate_grid.click
          wait_for_reservation_modal
          select_individual_room
          submit_reservation
          wait_for_exit_reservation_modal
          assert reservations?
          assert_equal 1, number_of_reservations
          force_confirm
          delete_reservation
        end
      end
    end
  end
end

class RoomsTest < NyuLibraries::Rooms::TestCase
  include NyuLibraries::Rooms::Reservation
end