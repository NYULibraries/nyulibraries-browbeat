=begin rdoc
==Core::Helpers
Basic common functions for testing and/or interacting with NYU libraries pages.

=== User Loops
Perform loops for users.
- Core::Helpers#for_all_consortium_users
- Core::Helpers#for_all_nyu_users

=== Login Actions
Perform basic login functions.
- Core::Helpers#login
- Core::Helpers#login_text
- Core::Helpers#logout
- Core::Helpers#logout_text

=== Waiting
Often it is necessary to wait for a particular event to occur before moving on to 
the next test, especially rendering.
- Core::Helpers#wait_for_login
- Core::Helpers#wait_for_logout

=end

module NyuLibraries
  module Core
    module Helpers
      module WaitHelpers
        # The common wait for element. If the element is found, it resolves true. A custom message can be set.
        def wait_for element, msg = "Error waiting for element #{element}"
          wait = Selenium::WebDriver::Wait.new(:timeout => 20)
          assert_nothing_raised(Selenium::WebDriver::Error::TimeOutError, "#{msg} on #{@tab.nil? ? "" : "tab #{@tab} and on "}view #{@view} and url #{@driver.current_url}.") {
            wait.until {
              begin
                send(element)
                true
              rescue Selenium::WebDriver::Error::NoSuchElementError, NoMethodError => e
                false
              end
            }
          }
        end
        
        # Unlike wait_for, this element waits for an element given the class of that element.
        def wait_for_element_by_class element_class, msg = "Error waiting for element with class #{element_class}"
          wait = Selenium::WebDriver::Wait.new(:timeout => 10)
          assert_nothing_raised(Selenium::WebDriver::Error::TimeOutError, "#{msg} on #{@tab.nil? ? "" : "tab #{@tab} and on "}view #{@view} and url #{@driver.current_url}.") {
            wait.until {
              begin
                @driver.find_element(:class, element_class)
                true
              rescue Selenium::WebDriver::Error::NoSuchElementError => e
                false
              end
            }
          }
        end
        
        # Wait for page title to show.
        def wait_for_page_title()
          wait_for :page_title, "Error waiting for page title to load"
        end
        
        # Wait for logout to process.  
        def wait_for_logout_page()
          wait_for :logout_page, "Error waiting for search for logout"
        end
        
        # Wait for shibboleth form to render. 
        def wait_for_shibboleth_form()
          wait_for :shibboleth_form, "Error waiting for pds"
        end
        
        # Wait for shibboleth button to appear.
        def wait_for_shibboleth_button_element()
          wait_for_element_by_class :btn, "Error waiting for shibboleth button"
        end
        
        # Wait for logout element to appear.
        def wait_for_logout_element()
          wait_for :logout_element, "No logout element/not logged in"
        end
        
        # Wait for logout element to appear.
        def wait_for_login_element()
          wait_for :login_element, "Error waiting for login element, you are possibly logged in "
        end
      end
    end
  end
end