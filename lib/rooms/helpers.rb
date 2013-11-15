module NyuLibraries
  module Rooms
    module Helpers
      def self.included(klass)
        klass.send :attr_reader, :views, :xpaths, :reserves_tabs, :views_sans_eshelf, :views_sans_access, :views_sans_login, :users
      end
      
      def for_each_view(&block)
        views.each_pair do |view, values|
          @view = view
          values["redirects"].each do |redirect|
            navigate_to "#{@rooms}"
            yield redirect
          end
        end
      end
      def pick_today
        @driver.find_element(:class, "ui-datepicker-today")
      end
      
      def individual_rooms
        wait_for_availability_grid_table
        table_rows = availability_grid_table.find_elements(:tag_name, "tr")
        table_rows.keep_if { |td| !td.text.match("Individual").nil? }
      end
      
      def individual_room index=0
        individual_rooms[index]
      end
      
      def select_individual_room index=0
        individual_rooms[index].find_element(:class, "new_reservation_radio_select").click
      end
      
      def submit_reservation
        @driver.find_element(:class, "btn-primary").click
      end
      
      def reservation_modal
        @driver.find_element(:id, "ajax-modal")
      end
      
      def wait_for_reservation_modal
        while !reservation_modal.displayed?
        end
      end
      
      def wait_for_exit_reservation_modal
        while reservation_modal.displayed?
        end
      end
      
      def force_confirm
        @driver.script('window.confirm = function() { return true; }')
      end
      
      def list_reservations
        wait_for_current_reservations
        current_reservations.find_elements(:tag_name, "li").reject {|li| li.text.eql?("None.")}
      end
      
      def reservation
          list_reservations.first
      end
      
      def delete_reservation index=0
        list_reservations[index].find_elements(:tag_name,"a").each {|a| a.click if a.text.eql? "delete reservation"}
      end
      
      def no_reservations?
        list_reservations.empty?
      end
      
      def reservations?
        !list_reservations.empty?
      end
      
      def number_of_reservations
        list_reservations.count
      end
    end
  end
end