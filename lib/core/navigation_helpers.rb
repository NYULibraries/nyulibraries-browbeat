module NyuLibraries
  module Core
    module Helpers
      module NavigationHelpers
        # Get the current page's title.
        def page_title()
         @driver.title
        end
        
        # Compare page title with title.
        def is_page_title?(title)
          wait_for_page_title
          page_title.eql?(title)
        end
        
        # A flow to return to the page after completing a certain action (ie login)
        def come_back_after(&block)
          previous_url = @driver.current_url
          yield
          navigate_to previous_url
        end
        
        # A quick way to navigate to another site.
        def navigate_to site
          @driver.navigate.to site
        end
        private :navigate_to  
      end
    end
  end
end