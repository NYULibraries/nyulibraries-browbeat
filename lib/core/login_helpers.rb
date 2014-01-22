module NyuLibraries
  module Core
    module Helpers
      module LoginHelpers
        # A login provided for NYU users. Provided with a user (hash containing username and password), this method
        # logs in with shibboleth and runs a block before logging out.
        def login_for_nyu(user, &block)
          login_with_shibboleth(user[:username], user[:password]) 
          yield
          logout
        end
        
        # A login provided for consortium users. Provided with a user (hash containing username and password), this method
        # logs in with PDS and runs a block before logging out.
        def login_for_consortium user, &block
          login_with_pds(user[:username], user[:password])
          yield
          logout
        end
        
        # A login method provided for NYU Home. Provided with a user (hash containing username and password), this method
        # logs in at NYU Home (provided by config) and runs a block before logging out.
        def login_for_nyu_home user, &block
          nyu_home_login(user[:username], user[:password]) 
          yield
          nyu_home_logout
        end
        
        # Return the login element
        def login_element()
          @driver.find_element(:css, "a.login")
        rescue
          @driver.find_element(:class, "nyulibrary_icons_login")
        end
        
        # Return the login text
        def login_text()
          wait_for_login_element
          login_element.text
        end
        
        # A check to see if the user is logged in. If the log out element isn't there, we assume logged in (maybe check cookies too?)
        def logged_in?
          wait_for_logout_element
        end
        
        # Check to see if the proper user is logged in. Checks the logged in user with a user hash that contains firstname.
        def logged_in_with_proper_user? user
          logged_in?
          assert_not_nil(logout_text.match(user[:firstname]), "Logged in but with wrong user! url: #{@driver.current_url} and view: #{@view}")
        end
        
        # Login by clicking the login link and then taking in a block to describe how to login.
        def login(&block)
          wait_for_login_element
          login_element.click
          yield if block_given?
        end
        
        # Login using pds, given the borid and pass.
        def login_with_pds borid, pass
          login do
            pds_login borid, pass
          end
        end
        
        # The pds login enters in the borid and pass and submits the login form.
        def pds_login(borid, pass)
          wait_for_nyu_pds_login_form
          bor_id.send_keys borid
          bor_verification.send_keys pass
          nyu_pds_login_form.submit
        end
        
        # NYU Home login goes to NYU Home and logs in there using netid and pass.
        def nyu_home_login netid, pass
          navigate_to "#{@nyu_home}" 
          shibboleth_form_login netid, pass
        end
        
        # The element representing the big shibboleth button.
        def shibboleth_button_element
          @driver.find_element(:css, "a.btn")
        end
        
        # The element representing the shibboleth form.
        def shibboleth_form()
          @driver.find_element(:css, "form#login")
        end
        
        # The element representing the shibboleth netid input.
        def shibboleth_netid()
          shibboleth_form.find_element(:css, "input#netid")
        end
        
        # The element representing the shibboleth password input.
        def shibboleth_pass()
          shibboleth_form.find_element(:css, "input#password")
        end
        
        # Login method using shibboleth, brings you to a shibboleth form page by clicking on the shibboleth button.
        def shibboleth_login netid, pass
          wait_for_shibboleth_button_element
          shibboleth_button_element.click
          shibboleth_form_login netid, pass
        end
        
        # Working with the shibboleth form to login.
        def shibboleth_form_login netid, pass
          wait_for_shibboleth_form
          shibboleth_netid.send_keys netid
          shibboleth_pass.send_keys pass
          shibboleth_form.submit
        end
        
        # A login flow describing a shibboleth login.
        def login_with_shibboleth netid, pass
          if shibboleth_button_element?
            shibboleth_login netid, pass
          else
            login do
              shibboleth_login netid, pass
            end
          end
        end
        
        # Return the logout element
        def logout_element()
          @driver.find_element(:css, "a.logout")
        rescue
          @driver.find_element(:class, "nyulibrary_icons_logout")
        end
        
        # An element only apparent in the logout page used to represent the logout page.
        def logout_page
          @driver.find_element(:css, ".logout > h1")
        end
        
        # Logout text
        def logout_text()
          wait_for_logout_element
          logout_element.text
        end
        
        # Logout
        def logout(&block)
          wait_for_logout_element
          logout_element.click
          yield if block_given?
          wait_for_logout_page
        end
        
        # Log out using NYU Home
        def nyu_home_logout
          navigate_to "#{@nyu_home}/logout"
          wait_for_logout_page
        end
        
        # Check to see if logged out.
        def logged_out?()
          wait_for_login_element
          # @cookies.each do |cookie|
          #   assert_nil(@driver.manage.cookie_named(cookie), "#{cookie} was not deleted.")
          # end
        end
      end
    end
  end
end