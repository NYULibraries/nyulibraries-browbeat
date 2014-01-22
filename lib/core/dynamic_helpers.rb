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
      module DynamicHelpers
        # Returns true if the method can be evaluated to a method name
        # and parameter.
        def respond_to? meth, include_private=false
          if(matches? meth)
            return true
          else
            super
          end
        end
        
        # Checks to see if the method matches any known method pattern.
        def matches? meth
          navigate_method?(meth) || element_id_method?(meth)  || wait_method?(meth) || element_id_exists_method?(meth)
        end
        private :matches?
        
        # Navigate methods use the navigate_to method and try to see if theres an instance variable available to navigate to.
        def navigate_method? meth
          (meth.to_s.start_with?("navigate_to_") && !instance_variable_get("@#{meth.to_s.sub('navigate_to_','')}").nil?)
        end
        private :navigate_method?
        
        # Element id methods see if there is an element with the given id on the current page.
        def element_id_method? meth
          @driver.find_element(:id, meth.to_s)
        rescue
          false
        end
        private :element_id_method?
        
        # Wait methods wait for certain elements to appear.
        def wait_method? meth
          meth.to_s.start_with?("wait_for_")
        end
        private :wait_method?
        
        # Element id exists methods check to see if the method even exists.
        def element_id_exists_method? meth
          meth.to_s[-1].eql?('?')
        end
        private :element_id_exists_method?
        
        # Method missing dynamically creates methods based on certain criteria. Currently, navigate methods, element id methods, wait
        # methods, and element id exists methods can be created.
        def method_missing(meth, *args, &block)
          # Check to see if it can be evaluated
          if(matches? meth)
            #Defines the method and caches it to the class
            self.class.send(:define_method, meth) do
              if element_id_exists_method?(meth)
                if respond_to?(meth.to_s.chop)
                  begin
                    send meth.to_s.chop
                  rescue Selenium::WebDriver::Error::NoSuchElementError => e
                    return false
                  end
                  return true
                end
              elsif wait_method?(meth)
                send :wait_for, meth.to_s.sub('wait_for_','').to_sym
              elsif navigate_method?(meth)
                send :navigate_to, instance_variable_get("@#{meth.to_s.sub('navigate_to_','')}")
              elsif element_id_method?(meth)
                @driver.find_element(:id, meth)
              end
            end
            # calls the method
            send meth, *args, &block
          else
            super
          end
        end
      end
    end
  end
end