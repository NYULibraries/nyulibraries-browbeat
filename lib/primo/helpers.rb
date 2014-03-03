=begin rdoc
== Primo Helpers
Basic functions for testing and/or interacting with Primo pages.

=== Looping Mechanisms
Allow tests to loop through views, tabs, sorts, etc
based on configuration setting in primo_views.yml.
- Primo::Helpers#each_view
- Primo::Helpers#each_view_redirects
- Primo::Helpers#each_view_tab
- Primo::Helpers#each_view_searches
- Primo::Helpers#each_view_default_precision_search
- Primo::Helpers#each_view_contains_search
- Primo::Helpers#each_view_exact_search
- Primo::Helpers#each_view_starts_with_search
- Primo::Helpers#each_view_sort

=== Section Tests
Test the existence and basic display of common sections of pages.
- Primo::Helpers#common_elements?
- Primo::Helpers#facets?
- Primo::Helpers#results?

=== Login Actions
Perform basic login functions.
- Primo::Helpers#login
- Primo::Helpers#login_text
- Primo::Helpers#logout
- Primo::Helpers#logout_text

=== Common Navigation
Common navigation for the Primo pages
- Primo::Helpers#navigate_to_tab
- Primo::Helpers#click_eshelf_link

=== Search Actions
Search actions allow tests to interact with search mechanisms.
- Primo::Helpers#submit_search
- Primo::Helpers#set_media_type
- Primo::Helpers#set_precision
- Primo::Helpers#set_scope1
- Primo::Helpers#set_scope2

=== Results Links
Results links allow interaction with the results links
- Primo::Helpers#click_details_link

=== Saving/Sending
Allows tests to interact with the save/send options.
Click the add to eshelf checkbox. Defaults to first record on brief screen.
- Primo::Helpers#click_add_to_eshelf
- Primo::Helpers#click_send_share
- Primo::Helpers#click_email_link
- Primo::Helpers#send_email
- Primo::Helpers#email_confirmation
- Primo::Helpers#close_email_modal
- Primo::Helpers#click_print_link
- Primo::Helpers#close_print_window

=== Selecting Elements
Select elements on the pages. Generally return Selenium::WebDriver::Element or
or an array of Selenium::WebDriver::Element.
- Primo::Helpers#header
- Primo::Helpers#nav1
- Primo::Helpers#login_element
- Primo::Helpers#logout_element
- Primo::Helpers#sidebar
- Primo::Helpers#sidebar_boxes
- Primo::Helpers#sidebar_box
- Primo::Helpers#sidebar_box_by_id
- Primo::Helpers#sidebar_account_box
- Primo::Helpers#sidebar_help_box
- Primo::Helpers#sidebar_additional_options_box
- Primo::Helpers#sidebar_box_items
- Primo::Helpers#sidebar_box_items_by_id
- Primo::Helpers#sidebar_account_box_items
- Primo::Helpers#sidebar_help_box_items
- Primo::Helpers#sidebar_additional_options_box_items
- Primo::Helpers#eshelf_link
- Primo::Helpers#search_container
- Primo::Helpers#tabs
- Primo::Helpers#search_form
- Primo::Helpers#search_field
- Primo::Helpers#facets
- Primo::Helpers#facets_boxes
- Primo::Helpers#facets_box
- Primo::Helpers#results
- Primo::Helpers#results_header
- Primo::Helpers#pagination_elements
- Primo::Helpers#results_list
- Primo::Helpers#add_to_eshelf_checkboxes
- Primo::Helpers#add_to_eshelf_checkbox
- Primo::Helpers#details_links
- Primo::Helpers#details_link
- Primo::Helpers#record_titles
- Primo::Helpers#record_title
- Primo::Helpers#eshelf_titles
- Primo::Helpers#eshelf_title
- Primo::Helpers#search_field

=== Waiting
Often it is necessary to wait for a particular event to occur before moving on to 
the next test.
- Primo::Helpers#wait_for_search_field
- Primo::Helpers#wait_for_search
- Primo::Helpers#wait_for_details
- Primo::Helpers#wait_for_email_modal
- Primo::Helpers#wait_for_email_send
- Primo::Helpers#wait_for_add_to_eshelf
- Primo::Helpers#wait_for_eshelf
- Primo::Helpers#wait_for_pds
- Primo::Helpers#wait_for_login
- Primo::Helpers#wait_for_logout

=end
module NyuLibraries
  module Primo
    module Helpers
      def self.included(klass)
        klass.send :attr_reader, :views, :xpaths, :reserves_tabs, :views_sans_eshelf, :views_sans_login, :users
      end
      
      # Loop through each view hash.
      def each_view(&block)
        views.each_key do |view|
          @view = view
          yield
        end
      end
  
      # Loop through each redirect for each view.
      def each_view_redirects(&block)
        views.each_pair do |view, values|
          @view = view
          values["redirects"].each do |redirect|
            yield redirect
          end
        end
      end
  
      # Loop through each tab for each view.
      def each_view_tab(&block)
        views.each_pair do |view, view_values|
          @view = view
          view_values["tabs"].each_pair do |tab, tab_values|
            @tab = tab
            navigate_to_tab
            yield tab_values
          end
        end
      end
  
      # Loop through each search hash for each tab for each view.
      # This method navigates to each tab.
      def each_view_searches(&block)
        each_view_tab do |tab_values|
          yield tab_values["searches"][@context]
        end
      end
  
      # Loop through the default search terms for each tab for each view.
      # This method navigates to each tab.
      def each_view_default_precision_search(&block)
        each_view_searches do |searches|
          default_precision = self.views[@view]["tabs"][@tab]["default_precision"]
          yield searches[default_precision]
        end
      end
  
      # Loop through the 'contains' search terms for each tab for each view.
      # This method navigates to each tab.
      def each_view_contains_search(&block)
        each_view_searches do |searches|
          yield searches["contains"]
        end
      end
  
      # Loop through the 'exact' search terms for each tab for each view.
      # This method navigates to each tab.
      def each_view_exact_search(&block)
        each_view_searches do |searches|
          yield searches["exact"]
        end
      end
  
      # Loop through the 'starts with' search terms for each tab for each view.
      # This method navigates to each tab.
      def each_view_starts_with_search(&block)
        each_view_searches do |searches|
          yield searches["starts_with"]
        end
      end
  
      # Loop through the sort options for each tab for each view.
      # This method navigates to each sort for the given view and tab.
      def each_view_sort(&block)
        sorts = self.views[@view]["tabs"][@tab]["sorts"]
        sorts.each_pair do |sort, sort_values|
          sort_by sort
          yield sort, sort_values
          @driver.navigate.refresh
        end
      end
      
      def for_all_nyu_users(&block)
        each_driver do
          nyu_users.each do |user|
            yield user
          end
        end
      end

      def for_all_nyu_users_search(&block)
        for_all_nyu_users do |user| 
          each_view_default_precision_search do |search_term|
            # Some views don't have a login, so we skip them.
            next if views_sans_login.include?(@view)
            yield user, search_term
          end
        end
      end
  
      # Test common elements:
      #   - header
      #   - top navigation (including breadcrumbs)
      #   - sidebar
      #   - search box
      #   - footer
      def common_elements?()
        assert_not_nil(@driver, "Driver is nill for view #{@view} and tab #{@tab}.")
        # Check header
        header?
        # Check nav1
        nav1?
        # Check sidebar
        sidebar?
        # Check search
        search?
        # Check footer
        footer?
      end
  
      # Test facets
      def facets?()
        # Don't check for facets on reserves tabs, since they are often not there.
        return if reserves_tabs.include?(@tab)
        assert_equal("div", facets.tag_name.downcase, "Tag name of facets element is not 'div' for view #{@view} and tab #{@tab}.")
        assert((not facets_boxes.empty?), "Facet boxes are empty for view #{@view} and tab #{@tab}.")
        facets_boxes.each do |box|
          facet_header = box.find_element(:tag_name, "h3")
          facet_list = box.find_element(:class, "facet_list")
          assert_equal("ul", facet_list.tag_name.downcase, "Tag name of facet list is not 'ul' for view #{@view} and tab #{@tab}")
        end
      end
  
      # Test results
      def results?()
        assert_equal("div", results.tag_name.downcase, "Tag name of results element is not 'div' for view #{@view} and tab #{@tab}.")
        results_header?
        pagination?
        results_list?
      end
      
      # Navigate to the current @view and @tab
      def navigate_to_tab()
        @driver.navigate.to "#{@search_url}?vid=#{@view}"
        wait = Selenium::WebDriver::Wait.new(:timeout => 20)
        wait.until {
          begin
            tabs.find_element(:css, "ul li##{@tab}")
            true
          rescue Selenium::WebDriver::Error::NoSuchElementError => e
            false
          end
        }
        tab = @driver.find_element(:css, "div#tabs ul li##{@tab}")
        tab.find_element(:tag_name, "a").click unless tab[:class].eql?("selected")
        wait_for_search_field
      end
    
      # Click the eshelf link in the sidebar.
      def click_eshelf_link()
        eshelf_link.click
        wait_for_eshelf
      end
    
      # Submit a search for the given search term.
      def submit_search(search_term)
        search_element = search_field
        search_element.clear
        search_element.send_keys "#{search_term}"
        search_element.submit
        wait_for_search search_term
      end
  
      # Set media type
      def set_media_type(media_type_value)
        media_type = Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "exlidInput_mediaType_1"))
        media_type.select_by(:value, media_type_value)
      end
  
      # Set precision operator
      def set_precision(precision_value)
        precision = Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "exlidInput_precisionOperator_1"))
        precision.select_by(:value, precision_value)
      end
  
      # Set scope 1
      def set_scope1(scope1_value)
        scope1 = Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "exlidInput_scope_1"))
        scope1.select_by(:value, scope1_value)
      end
  
      # Set scope 2
      def set_scope2(scope2_value)
        scope2 = Selenium::WebDriver::Support::Select.new(@driver.find_element(:name, "scp.scps"))
        scope2.select_by(:value, scope2_value)
      end
    
      # Click the details link. Defaults to first link
      def click_details_link(index=0)
        title = record_title(index)
        details_link(index).click
        wait_for_details(title)
      end
  
      # Click the add to eshelf checkbox. Defaults to first record on brief screen.
      def click_add_to_eshelf(index=0)
        add_to_eshelves = @driver.find_elements(:css, ".save_record input.tsetse_generated")
        add_to_eshelves[index].click
      end
      
      # Click the send/share button. Defaults to first record on brief screen.
      def click_send_share(index=0)
        send_shares = @driver.find_elements :xpath, xpaths[:send_share]
        send_shares[index].click
      end
  
      # Click the email link. Defaults to first record on brief screen.
      def click_email_link(index=0)
        email_links = @driver.find_elements :xpath, xpaths[:email_link]
        email_links[index].click
        wait_for_email_modal
      end
      
      # Send an email to the given email address.
      def send_email(email_address)
        subject = @driver.find_element(:css, '.ui-dialog .ui-dialog-content form input#subject')
        subject.send_keys " - Jenkins probably sent this to you."
        to = @driver.find_element(:css, '.ui-dialog .ui-dialog-content form input#sendTo')
        to.send_keys email_address
        to.submit
        wait_for_email_send
      end
      
      # Get the email confirmation message
      def email_confirmation()
        @driver.find_element(:css, '.ui-dialog .ui-dialog-content div')
      end
      
      # Close the email modal window
      def close_email_modal()
        @driver.find_element(:css, '.ui-dialog .ui-dialog-titlebar .ui-icon-closethick').click
      end
  
      # Click the print link. Defaults to first record on brief screen.
      # Switches to the print window.
      def click_print_link(index=0)
        print_links = @driver.find_elements :xpath, xpaths[:print_link]
        print_links[index].click
        @driver.switch_to.window(@driver.window_handles.last)
      end
      
      # Close the print window
      def close_print_window()
        # Close the window
        @driver.close
        # Switch back to original window.
        @driver.switch_to.window(@driver.window_handles.first)
      end
      
      # Return the header element
      def header()
        @driver.find_element(:id, "header")
      end
      
      # Return the nav1 element
      def nav1()
        @driver.find_element(:id, "nav1")
      end
      
      # Return the sidebar element
      def sidebar()
        @driver.find_element(:id, "sidebar")
      end
    
      # Return the array of sidebar boxes
      def sidebar_boxes()
        wait_for_sidebar
        sidebar.find_elements(:class, "box")
      end
    
      # Return the specified sidebar box. Default to the first box.
      def sidebar_box(index=0)
        sidebar_boxes[index]
      end
      
      # Return the specified sidebar box identified by the specified id
      def sidebar_box_by_id(id)
        wait_for_sidebar
        sidebar.find_element(:id, id)
      end
      
      # Return the account box
      def sidebar_account_box()
        sidebar_box_by_id("account")
      end
      
      # Return the help box
      def sidebar_help_box()
        sidebar_box_by_id("help")
      end
      
      # Return the additional options box
      def sidebar_additional_options_box()
        sidebar_box_by_id("additional_options")
      end
      
      # Return the array of list items for the sidebar box identified by the specified index.  Default to first box.
      def sidebar_box_items(index=0)
        sidebar_box(index).find_elements(:tag_name, "li")
      end
      
      # Return the array of list items for the sidebar box identified by the specified id
      def sidebar_box_items_by_id(id)
        sidebar_box_by_id(id).find_elements(:tag_name, "li")
      end
      
      # Return the array of account box items
      def sidebar_account_box_items()
        sidebar_box_items_by_id("account")
      end
      
      # Return the array of help box items
      def sidebar_help_box_items()
        sidebar_box_items_by_id("help")
      end
      
      # Return the array of additional options box items
      def sidebar_additional_options_box_items()
        sidebar_box_items_by_id("additional_options")
      end
      
      # Return the eshelf link
      def eshelf_link()
        eshelf_index = (@view.eql?("NYSID")) ? (@driver.find_elements(:css, "a.logout").empty? ? 2 : 1 ) : 0
        sidebar_account_box_items[eshelf_index].find_element(:tag_name, "a")
      end
      
      # Return the search_container element
      def search_container()
        @driver.find_element(:id, "search_container")
      end
    
      # Return the tabs element
      def tabs()
        search_container.find_element(:id, "tabs")
      end
    
      # Return the search_form element
      def search_form()
        search_container.find_element(:name, "searchForm")
      end
    
      # Return the search field element
      def search_field()
        search_form.find_element(:id, "search_field")
      end
      
      # Return the facets element
      def facets()
        @driver.find_element(:id, "facets")
      end
      
      # Return the array of facet boxes
      def facets_boxes()
        facets.find_elements(:class, "box")
      end
  
      # Return the specified facet box. Default to the first box.
      def facets_box(index=0)
        facetss_boxes[index]
      end
      
      # Return the results element
      def results()
        @driver.find_element(:id, "results")
      end
  
      # Return the results header element
      def results_header()
        results.find_element(:id, "results_header")
      end
      
      # Return the array of pagination elements
      def pagination_elements()
        results.find_elements(:class, "pagination")
      end
      
      # Return the results list element
      def results_list()
        results.find_element(:id, "resultsList")
      rescue
        return nil
      end
      
      def wait_for_results_list()
        wait = Selenium::WebDriver::Wait.new(:timeout => 10)
        assert_nothing_raised(Selenium::WebDriver::Error::TimeOutError, "Error waiting for search for logout #{@driver.current_url} view #{@view} and tab #{@tab}.") {
          wait.until {
            begin
              results_list
              true
            rescue Selenium::WebDriver::Error::NoSuchElementError => e
              false
            end
          }
        }
      end
      
      # Return the array of results list items
      def results_list_items()
        results_list.find_elements(:class, "result")
      end
  
      # Return the specified results list item. Default to the first item
      def results_list_items(index=0)
        results_list_items[index]
      end
  
      # Return an array of Primo add to eshelf checkboxes
      def add_to_eshelf_checkboxes()
        @driver.find_elements(:css, ".save_record input.tsetse_generated")
      end
      
      # Return the specified Primo add to eshelf checkbox. Default to the first checkbox.
      def add_to_eshelf_checkbox(index=0)
        add_to_eshelf_checkboxes[index]
      end
      
      # Return an array of Primo details link elements
      def details_links()
        results_list.find_elements(:css, ".fulldetails a")
      end
      
      # Return the specified Primo details link. Default to the first checkbox.
      def details_link(index=0)
        details_links[index]
      end
      
      # Return the list of Primo title strings
      def record_titles()
        titles = []
        @driver.find_elements(:css, ".entree h2.title").each do |title|
          titles << title.text
        end
        return titles
      end
      
      # Return the specified Primo title string. Default to the first title.
      def record_title(index=0)
        record_titles[index]
      end
    
      # Return the list of e-shelf title strings
      def eshelf_titles()
        titles = []
        @driver.find_elements(:css, '.entree h2.title').each do |title|
          titles << title.text
        end
        return titles
      end
      
      # Return the specified e-shelf title string. Default to the first title.
      def eshelf_title(index=0)
        eshelf_titles[index]
      end
  
      # Return the footer element
      def footer()
        @driver.find_element(:id, "footer")
      end
      
      def wait_for_sidebar()
        wait = Selenium::WebDriver::Wait.new(:timeout => 10)
        assert_nothing_raised(Selenium::WebDriver::Error::TimeOutError, "Error waiting for search field for url #{@driver.current_url} view #{@view} and tab #{@tab}.") {
          wait.until {
            begin
              sidebar
              true
            rescue Selenium::WebDriver::Error::NoSuchElementError => e
              false
            end
          }
        }
      end
    
      # Wait for the search field to display
      def wait_for_search_field()
        wait = Selenium::WebDriver::Wait.new(:timeout => 10)
        assert_nothing_raised(Selenium::WebDriver::Error::TimeOutError, "Error waiting for search field for url #{@driver.current_url} view #{@view} and tab #{@tab}.") {
          wait.until {
            begin
              search_field
              true
            rescue Selenium::WebDriver::Error::NoSuchElementError => e
              false
            end
          }
        }
      end
  
      # Wait for the search for the 'search_term' to complete
      def wait_for_search(search_term)
        wait = Selenium::WebDriver::Wait.new(:timeout => 10)
        assert_nothing_raised(Selenium::WebDriver::Error::TimeOutError, "Error waiting for search for url #{@driver.current_url} view #{@view} and tab #{@tab}.") {
          wait.until {
            begin
              search_field
              @driver.title.eql?("BobCat - #{search_term}")
            rescue Selenium::WebDriver::Error::NoSuchElementError => e
              false
            end
          }
        }
      end
      
      # Wait for the full details page for the given 'title' to render
      def wait_for_details(title)
        wait = Selenium::WebDriver::Wait.new(:timeout => 10)
        assert_nothing_raised(Selenium::WebDriver::Error::TimeOutError, "Error waiting for details for url #{@driver.current_url} view #{@view} and tab #{@tab}.") {
          wait.until {
            @driver.title.eql?("BobCat - #{title}")
          }
        }
      end
      
      # Wait for the email modal to display.  Generally Primo::Helpers#click_email_link should be used instead
      def wait_for_email_modal()
        wait = Selenium::WebDriver::Wait.new(:timeout => 10)
        assert_nothing_raised(Selenium::WebDriver::Error::TimeOutError, "Error waiting for email modal for url #{@driver.current_url} view #{@view} and tab #{@tab}.") {
          wait.until {
            begin
              @driver.find_element(:css, ".ui-dialog .ui-dialog-content form#mailFormId")
              true
            rescue Selenium::WebDriver::Error::NoSuchElementError => e
              false
            end
          }
        }
      end
      
      # Wait for the email to send.  Generally Primo::Helpers#send_email should be used instead
      def wait_for_email_send()
        wait = Selenium::WebDriver::Wait.new(:timeout => 10)
        assert_nothing_raised(Selenium::WebDriver::Error::TimeOutError, "Error waiting for email to send for url #{@driver.current_url} view #{@view} and tab #{@tab}.") {
          wait.until {
            begin
              email_confirmation
              true
            rescue Selenium::WebDriver::Error::NoSuchElementError => e
              false
            end
          }
        }
      end
      
      # Wait to add to the eshelf.  Generally Primo::Helpers#add_to_eshelf should be used instead
      def wait_for_add_to_eshelf(index=0)
        wait = Selenium::WebDriver::Wait.new(:timeout => 10)
        assert_nothing_raised(Selenium::WebDriver::Error::TimeOutError, "Error waiting to add to eshelf for url #{@driver.current_url} view #{@view} and tab #{@tab}.") {
          wait.until {
            wait = Selenium::WebDriver::Wait.new(:timeout => 10)
            wait.until { 
              (not @driver.find_elements(:css => ".save_record label.tsetse_generated")[index].text.match("^In").nil?)
            }
          }
        }
      end
      
      # Wait to add to the eshelf.  Generally Primo::Helpers#add_to_eshelf should be used instead
      def wait_for_uncheck_add_to_eshelf(index=0)
        wait = Selenium::WebDriver::Wait.new(:timeout => 10)
        assert_nothing_raised(Selenium::WebDriver::Error::TimeOutError, "Error waiting to add to eshelf for url #{@driver.current_url} view #{@view} and tab #{@tab}.") {
          wait.until {
            wait = Selenium::WebDriver::Wait.new(:timeout => 10)
            wait.until { 
              (not @driver.find_elements(:css => ".save_record label.tsetse_generated")[index].text.match("^Add").nil?)
            }
          }
        }
      end
      
      # Wait for the eshelf to render.  Generally Primo::Helpers#click_eshelf_link should be used instead
      def wait_for_eshelf()
        wait = Selenium::WebDriver::Wait.new(:timeout => 10)
        assert_nothing_raised(Selenium::WebDriver::Error::TimeOutError, "Error waiting for eshelf for url #{@driver.current_url} view #{@view} and tab #{@tab}.") {
          wait.until {
            @driver.find_element(:css, "h1").text == "e-Shelf"
          }
        }
      end
      
      # Wait for pds to render.  Generally Primo::Helpers#login should be used instead
      def wait_for_pds()
        wait = Selenium::WebDriver::Wait.new(:timeout => 10)
        assert_nothing_raised(Selenium::WebDriver::Error::TimeOutError, "Error waiting for pds for url #{@driver.current_url} view #{@view} and tab #{@tab}.") {
          wait.until {
            @driver.title.eql?("BobCat")
          }
        }
      end
      
      # Wait for shibboleth to render.
      def wait_for_shibboleth_button()
        wait = Selenium::WebDriver::Wait.new(:timeout => 10)
        assert_nothing_raised(Selenium::WebDriver::Error::TimeOutError, "Error waiting for pds for url #{@driver.current_url} view #{@view} and tab #{@tab}.") {
          wait.until {
            begin
              shibboleth_button
              true
            rescue Selenium::WebDriver::Error::NoSuchElementError => e
              false
            end
          }
        }
      end
      
      # Wait for shibboleth form to render. 
      def wait_for_shibboleth_form()
        wait = Selenium::WebDriver::Wait.new(:timeout => 10)
        assert_nothing_raised(Selenium::WebDriver::Error::TimeOutError, "Error waiting for pds for url #{@driver.current_url} view #{@view} and tab #{@tab}.") {
          wait.until {
            begin
              shibboleth_form
              true
            rescue Selenium::WebDriver::Error::NoSuchElementError => e
              false
            end
          }
        }
      end
      
      # Wait for login to process.  Generally Primo::Helpers#login should be used instead
      def wait_for_login()
        wait = Selenium::WebDriver::Wait.new(:timeout => 10)
        assert_nothing_raised(Selenium::WebDriver::Error::TimeOutError, "Error waiting for login for url #{@driver.current_url} view #{@view} and tab #{@tab}.") {
          wait.until {
            begin
              logout_element
              true
            rescue Selenium::WebDriver::Error::NoSuchElementError => e
              false
            end
          }
        }
      end
      
      # Wait for logout to process.  Generally Primo::Helpers#logout should be used instead
      def wait_for_logout()
        wait = Selenium::WebDriver::Wait.new(:timeout => 10)
        assert_nothing_raised(Selenium::WebDriver::Error::TimeOutError, "Error waiting for search for logout #{@driver.current_url} view #{@view} and tab #{@tab}.") {
          wait.until {
            begin
              @driver.find_element(:css, ".logout > h1")
              true
            rescue Selenium::WebDriver::Error::NoSuchElementError => e
              false
            end
          }
        }
      end
  
      private
      def sort_by(sort_value)
        sort_select = Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "srt"))
        sort_select.select_by(:value, sort_value)
      end
  
      def header?()
        # Is the header div present?
        assert_equal("div", header.tag_name.downcase, "Tag name of header element is not 'div' for view #{@view} and tab #{@tab}.")
        bobcat_spans = header.find_elements(:tag_name, "span")
        assert_equal(2, bobcat_spans.size(), "Header spans return an unexpected size for view #{@view} and tab #{@tab}.")
        bobcat_spans.each do |span|
          # The header spans are hidden
          assert_equal("", span.text, "Header span is not hidden for view #{@view} and tab #{@tab}.")
        end
      end
    
      def nav1?()
        # Is the nav1 div present?
        assert_equal("div", nav1.tag_name.downcase, "Tag name of nav1 element is not 'div' for view #{@view} and tab #{@tab}.")
        assert_equal("ul", nav1.find_element(:class, "floatLeft").tag_name.downcase, "Tag name of left nav1 list element is not 'ul' for view #{@view} and tab #{@tab}.")
        assert_equal("ul", nav1.find_element(:class, "floatRight").tag_name.downcase, "Tag name of right nav1 list element is not 'ul' for view #{@view} and tab #{@tab}.")
      end
    
      def sidebar?()
        # Is the sidebar div present?
        assert_equal("div", sidebar.tag_name.downcase, "Tag name of sidebar element is not 'div' for view #{@view} and tab #{@tab}.")
        assert((not sidebar_boxes.empty?), "Sidebar boxes are empty for view #{@view} and tab #{@tab}.")
      end
      
      def search?()
        # Is the search_container div present?
        assert_equal("div", search_container.tag_name.downcase, "Tag name of search container element is not 'div' for view #{@view} and tab #{@tab}.")
        tabs?
        assert_equal("form", search_form.tag_name.downcase, "Tag name of search form element is not 'form' for view #{@view} and tab #{@tab}.")
      end
    
      def tabs?()
        assert_equal("div", tabs.tag_name.downcase, "Tag name of tabs element is not 'div' for view #{@view} and tab #{@tab}.")
        assert((not tabs.find_elements(:tag_name, "li").empty?), "Tabs are empty for view #{@view} and tab #{@tab}.")
      end
    
      def footer?()
        # Is the footer div present?
        assert_equal("div", footer.tag_name.downcase, "Tag name of footer element is not 'div' for view #{@view} and tab #{@tab}.")
        assert_not_nil(footer.text.match("Powered by Ex Libris Primo"), "Footer text is unexpected for view #{@view} and tab #{@tab}.")
      end
  
      def results_header?()
        assert_equal("div", results_header.tag_name.downcase, "Tag name of results header element is not 'div' for view #{@view} and tab #{@tab}.")
      end
      
      def results_list?()
        wait_for_results_list
        assert(!results_list.nil?, "No search results were found url for #{@driver.current_url} view #{@view} and tab #{@tab}")
        assert_equal("ul", results_list.tag_name.downcase, "Tag name of results list element is not 'ul' for view #{@view} and tab #{@tab}.")
        results_list_items = results_list.find_elements(:class, "result")
        assert((not results_list_items.empty?), "Results list is empty for view #{@view} and tab #{@tab}.")
        # Check number of results unless we're on a reserves tab, since they can be finicky.
        assert_operator(10, :>=, results_list_items.size(), "Results list returned an unexpected number of results for view #{@view} and tab #{@tab}.") unless reserves_tabs.include?(@tab)
        results_list_items.each do |results_list_item|
          assert_equal("li", results_list_item.tag_name.downcase, "Tag name of result list item element is not 'li' for view #{@view} and tab #{@tab}.")
        end
      end
    
      def pagination?()
        assert((not pagination_elements.empty?), "Pagination elements are empty for view #{@view} and tab #{@tab}.")
        assert_equal(2, pagination_elements.size(), "Paginination elements return an unexpected size for view #{@view} and tab #{@tab}.")
        pagination_elements.each do |pagination_element|
          assert_equal("div", pagination_element.tag_name.downcase, "Tag name of pagination element is not 'div' for view #{@view} and tab #{@tab}.")
        end
      end
    end
  end
end