=begin rdoc
== SendShare
Tests for Primo send/share functionality.

=end
require File.expand_path("#{File.dirname(__FILE__)}/../test_case")
module NyuLibraries::Primo::SendShare
  # def test_email
  #   @current_test_name = "Primo - Testing Email (Default Precision Operator Search)"
  #   each_driver do
  #     each_view_default_precision_search do |search_term|
  #       # Search Primo
  #       submit_search search_term
  #       email_test = lambda { |email|
  #         # Click the Send/Share button
  #         click_send_share
  #         # Click the E-mail link
  #         click_email_link
  #         # Send the E-mail
  #         send_email email
  #         # Get the confirmation message and ensure it's what it should be
  #         assert_equal("Your message has been sent.", email_confirmation.text, "Unexpected confirmation text after sending email for view #{@view} and tab #{@tab}.")
  #         # Close email modal
  #         close_email_modal
  #       }
  #       # Test email for brief results page
  #       email_test.call @email1
  #       email_test.call @email2
  #       # Click details link
  #       click_details_link
  #       # Test email for full details page
  #       email_test.call @email1
  #       email_test.call @email2
  #     end
  #   end
  # end
  # 
  # def test_print
  #   skip("Printing is inconsistent across browsers in Selenium and the tests sometimes timeout so we're skipping this test for the moment.")
  #   @current_test_name = "Primo - Testing Print (Default Precision Operator Search)"
  #   each_driver do
  #     each_view_default_precision_search do |search_term|
  #       # Search Primo
  #       submit_search search_term
  #       print_test = lambda {
  #         # Click the Send/Share button
  #         click_send_share
  #         # Click the Print link and switch to the print window
  #         click_print_link
  #         # Ensure the page title is correct
  #         assert_not_nil(@driver.title.match("(Print - )?BobCat$"), "Unexpected page title after print for view #{@view} and tab #{@tab}.")
  #         # Ensure the page is the print page
  #         assert_nothing_raised Selenium::WebDriver::Error::NoSuchElementError do
  #           @driver.find_element(:css, ".EXLPrintableLayoutTable")
  #         end
  #         # Close the print window.
  #         close_print_window
  #       }
  #       # Test print for brief results page
  #       print_test.call
  #       # Click details link
  #       click_details_link
  #       # Test print for full details page
  #       print_test.call
  #     end
  #   end
  # end
  
  def test_add_to_eshelf
    @current_test_name = "Primo - Testing Add to E-Shelf (Default Precision Operator Search)"
    each_driver do
      each_view_default_precision_search do |search_term|
        next unless @view.eql?("NYU")
        # Reset the session
        clear_cookies
        # Skip this test if the view is not using the e-shelf
        next if views_sans_eshelf.include?(@view)
        # Search Primo
        submit_search search_term
        add_to_eshelf_test = lambda {
          # Grab the Primo title for comparison
          p_title = record_title
          # Save the eshelf record
          click_add_to_eshelf
          wait_for_add_to_eshelf
          come_back_after do
            # Go to the eshelf
            click_eshelf_link
            wait_for_eshelf
            assert_not_nil(@driver.current_url.match("eshelf"), "Did not go to eshelf for view #{@view} and tab #{@tab}.")
            # Grab the E-Shelf title for comparison
            e_title = eshelf_title
            # Assert that the title was saved to the e-shelf
            assert_equal(p_title, e_title, "Primo title differs from eshelf title after add for view #{@view} and tab #{@tab}.")
            # Go back to Primo
          end
        }
        # Test add to eshelf for brief results page
        add_to_eshelf_test.call
        @driver.navigate.refresh
        # Click details link of the second item
        click_details_link 1
        # Test add to eshelf for full details page
        add_to_eshelf_test.call
      end
    end
  end
end

class PrimoTest < NyuLibraries::Primo::TestCase
  # include NyuLibraries::Primo::SendShare
end