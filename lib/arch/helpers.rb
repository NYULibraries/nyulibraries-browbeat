module NyuLibraries
  module Arch
    module Helpers
      def self.included(klass)
        klass.send :attr_reader, :views, :xpaths, :reserves_tabs, :views_sans_eshelf, :views_sans_access, :views_sans_footer, :views_sans_login, :campus, :users
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
            navigate_to_view redirect
            yield redirect
          end
        end
      end
      
      def login_for_nyu user, &block
        login_with_shibboleth(user[:username], user[:password]) 
        yield
        logout do
          wait_for_logout_submit
          @driver.find_element(:class, "submit_logout").click
        end
      end
      
      def wait_for_logout_submit
        wait = Selenium::WebDriver::Wait.new(:timeout => 10)
        assert_nothing_raised(Selenium::WebDriver::Error::TimeOutError, "Error waiting for title for url #{@driver.current_url} view #{@view} and tab #{@tab}.") {
          wait.until {
            begin
              @driver.find_element(:class, "submit_logout")
              true
            rescue Selenium::WebDriver::Error::NoSuchElementError => e
              false
            end
          }
        }
      end
      
      def databases_by_subject()
        ( database_categories.find_element(:css, "div.yui-u.first").find_elements(:tag_name, "a") <<  database_categories.find_element(:css, "div.yui-u.second").find_elements(:tag_name, "a")).flatten
      end
      
      def wait_for_arch()
        wait = Selenium::WebDriver::Wait.new(:timeout => 10)
        assert_nothing_raised(Selenium::WebDriver::Error::TimeOutError, "Error waiting for title for url #{@driver.current_url} view #{@view} and tab #{@tab}.") {
          wait.until {
            begin
              @driver.find_element(:id, "bobcat_logo")
              true
            rescue Selenium::WebDriver::Error::NoSuchElementError => e
              false
            end
          }
        }
      end
      
      def wait_for_database_categories()
        wait = Selenium::WebDriver::Wait.new(:timeout => 10)
        assert_nothing_raised(Selenium::WebDriver::Error::TimeOutError, "Error waiting for databases for url #{@driver.current_url} view #{@view} and tab #{@tab}.") {
          wait.until {
            begin
              database_categories
              true
            rescue Selenium::WebDriver::Error::NoSuchElementError => e
              false
            end
          }
        }
      end
          
      def database_categories
        @driver.find_element(:id => "databases_categories")
      end
      
      def navigate_to_view redirect
        @driver.navigate.to "#{@arch}#{redirect}"
        wait_for_database_categories
      end
  
  
      def each_view_default_searches(&block)
        each_view_redirects do
          next if views_sans_access.include?(@view)
          databases_by_subject.keep_if{ |database| database.text.eql? views[@view]['databases']['default_database']}.first.click        
          wait_for_search_field
          yield views[@view]['databases']['searches']
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
        # Check breadcrumb
        breadcrumb?
        # Check sidebar
        sidebar?
        # Check footer
        footer?
      end
      
      # Test facets
      def facets?()
        # Don't check for facets on reserves tabs, since they are often not there.
        assert_equal("div", facets.tag_name.downcase, "Tag name of facets element is not 'div' for view #{@view} and tab #{@tab}.")
        assert((not facets_boxes.empty?), "Facet boxes are empty for view #{@view} and tab #{@tab}.")
        facets_boxes.each do |box|
          assert_nothing_raised(Selenium::WebDriver::Error::NoSuchElementError, "Header name of facet list is not found for view #{@view} and tab #{@tab}"){
            facet_header = box.find_element(:tag_name, "h2")
          }
          assert_nothing_raised(Selenium::WebDriver::Error::NoSuchElementError, "Tag name of facet list is not 'ul' for view #{@view} and tab #{@tab}"){
            facet_list = box.find_element(:tag_name, "ul")
          }
        end
      end
      
      # Test results
      def results?()
        assert_equal("div", results.tag_name.downcase, "Tag name of results element is not 'div' for view #{@view} and tab #{@tab}.")
        pagination?
        results_list?
      end
        
      
      # Submit a search for the given search term.
      def submit_search(search_term)
        wait_for_search_field
        search_element = search_field
        search_element.clear
        search_element.send_keys "#{search_term}"
        search_element.submit
        wait_for_search search_term
      end
      
      # Set scope 1
      def set_scope1(scope1_value)
        wait_for_scope1
        scope_select = Selenium::WebDriver::Support::Select.new(scope1)
        scope_select.select_by(:value, scope1_value)
      end
      
      def scope1()
        @driver.find_element(:id, "field")
      end
      
      def wait_for_scope1()
        wait = Selenium::WebDriver::Wait.new(:timeout => 10)
        assert_nothing_raised(Selenium::WebDriver::Error::TimeOutError, "Error waiting for search for logout #{@driver.current_url} view #{@view} and tab #{@tab}.") {
          wait.until {
            begin
              scope1
              true
            rescue Selenium::WebDriver::Error::NoSuchElementError => e
              false
            end
          }
        }
      end
      
      # Click the details link. Defaults to first link
      def click_details_link(index=0)
        title = record_title(index)
        details_link(index).click
        wait_for_details
      end
      
      # Return the header element
      def header()
        @driver.find_element(:id, "header")
      end
        
      # Return the breadcrumb element
      def breadcrumb()
        @driver.find_element(:id, "breadcrumb")
      end
        
      # Return the sidebar element
      def sidebar()
        @driver.find_elements(:class_name, "yui-b").last
      end
      
      # Return the array of sidebar boxes
      def sidebar_boxes()
        sidebar.find_elements(:class_name, "box")
      end
      
      # Return the search field element
      def search_field()
        @driver.find_element(:id, "query")
      end
        
      # Return the facets element
      def facets()
        @driver.find_element(:id, "metasearch_results_facets")
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
        @driver.find_element(:id, "metasearch_results_results")
      end
        
      # Return the array of pagination elements
      def pagination_elements()
        (@driver.find_elements(:class, "pagination") << @driver.find_elements(:class, "resultsPager")).flatten
      end
        
      # Return the results list element
      def results_list()
        results.find_element(:id, "results")
      end
      
      # Return the array of results list items
      def results_list_items()
        results_list.find_elements(:class, "result")
      end
      
      # Return the specified results list item. Default to the first item
      def results_list_items(index=0)
        results_list_items[index]
      end
      
      # Return an array of Primo details link elements
      def details_links()
        results_list.find_elements(:class, "resultsRecordDetail>a")
      end
        
      # Return the specified Primo details link. Default to the first checkbox.
      def details_link(index=0)
        details_links[index]
      end
        
      # Return the list of Primo title strings
      def record_titles()
        titles = []
        results_list.find_elements(:class, "resultsTitle").each do |title|
          titles << title.text
        end
        return titles
      end
        
      # Return the specified Primo title string. Default to the first title.
      def record_title(index=0)
        record_titles[index]
      end
      
      # Return the footer element
      def footer()
        @driver.find_element(:id, "ft")
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
        wait = Selenium::WebDriver::Wait.new(:timeout => 45)
        assert_nothing_raised(Selenium::WebDriver::Error::TimeOutError, "Error waiting for search for url #{@driver.current_url} view #{@view} and tab #{@tab}.") {
          wait.until {
            begin
              @driver.find_element(:id, "metasearch_results_results")
            rescue Selenium::WebDriver::Error::NoSuchElementError => e
              login_page?
            end
          }
        }
      end
        
      # Wait for the full details page for the given 'title' to render
      def wait_for_details()
        wait = Selenium::WebDriver::Wait.new(:timeout => 10)
        assert_nothing_raised(Selenium::WebDriver::Error::TimeOutError, "Error waiting for details for url #{@driver.current_url} view #{@view} and tab #{@tab}.") {
          wait.until {
            @driver.title.eql?("BobCat")
          }
        }
      end
      
      def login_page?()
        shibboleth_button_element
        true
      rescue Selenium::WebDriver::Error::NoSuchElementError => e
        false
      end
  
      
      def header?()
        # Is the header div present?
        assert_equal("div", header.tag_name.downcase, "Tag name of header element is not 'div' for view #{@view} and tab #{@tab}.")
        bobcat_spans = header.find_elements(:tag_name, "span")          
        assert_equal(1, bobcat_spans.size(), "Header spans return an unexpected size for view #{@view} and tab #{@tab}.")
        bobcat_spans.each do |span|
          # The header spans are hidden
          assert_equal("", span.text, "Header span is not hidden for view #{@view} and tab #{@tab}.")
        end
      end
      
      def breadcrumb?()
        # Is the breadcrumb div present?
        assert_equal("div", breadcrumb.tag_name.downcase, "Tag name of breadcrumb element is not 'div' for view #{@view} and tab #{@tab}.")
        case @view
        when "NYUAD"#, "NS"
          assert(breadcrumb.text.include?("BobCat > #{views[@view]["breadcrumb"]} > Articles & Databases"), "Breadcrumb is not '#{views[@view]["breadcrumb"]} > BobCat > Articles & Databases for view #{@view} and tab #{@tab}.")
        when "NYUSH", "NYU"
          assert(breadcrumb.text.include?("#{views[@view]["breadcrumb"]} > BobCat > Articles & Databases"), "Breadcrumb is not 'BobCat > #{views[@view]["breadcrumb"]} > Articles & Databases for view #{@view} and tab #{@tab}.")
        else
          assert(breadcrumb.text.include?("BobCat"), "Breadcrumb does not contain 'BobCat' for view #{@view} and tab #{@tab}.")
          assert(breadcrumb.text.include?("Articles"), "Breadcrumb does not contain Articles & Databases for view #{@view} and tab #{@tab}.")
        end
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
  
      def footer?()
        # Is the footer div present?
        assert_equal("div", footer.tag_name.downcase, "Tag name of footer element is not 'div' for view #{@view} and tab #{@tab}.")
        assert_not_nil(footer.text.match("Powered by Xerxes"), "Footer text is unexpected, expected to contain <Powered by Xerxes> but is <#{footer.text}> for view #{@view} and tab #{@tab}.") unless views_sans_footer.include?(@view)
      end
      
        
      def results_list?()
        assert_equal("ul", results_list.tag_name.downcase, "Tag name of results list element is not 'ul' for view #{@view} and tab #{@tab}.")
        results_list_items = results_list.find_elements(:class, "result")
        assert((not results_list_items.empty?), "Results list is empty for view #{@view} and tab #{@tab}.")
        # Check number of results unless we're on a reserves tab, since they can be finicky.
        assert_equal(10, results_list_items.size(), "Results list returned an unexpected number of results for view #{@view} and tab #{@tab}.")
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
      
      def click_eshelf_link()
        eshelf_link.click
        wait_for_eshelf
      end
      
      def click_add_to_eshelf(index=0)
        add_to_eshelf_checkboxes[index].click
      end
      
      def sidebar_box_by_id(id)
        sidebar.find_element(:id, id)
      end
      
      def sidebar_box_items_by_id(id)
        sidebar_box_by_id(id).find_elements(:tag_name, "li")
      end
        
        # Return the array of account box items
      def sidebar_account_box_items()
        sidebar_box_items_by_id("account")
      end
          
      def eshelf_link()
        eshelf_index = (@view.eql?("NYSID")) ? 2 : 0
        sidebar_account_box_items[eshelf_index].find_element(:tag_name, "a")
      end
      
      def add_to_eshelf_checkboxes()
        @driver.find_elements(:css, "input.tsetse_generated")
      end
        
      # Return the specified Primo add to eshelf checkbox. Default to the first checkbox.
      def add_to_eshelf_checkbox(index=0)
        add_to_eshelf_checkboxes[index]
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
      
      def wait_for_add_to_eshelf(index=0)
        wait = Selenium::WebDriver::Wait.new(:timeout => 10)
        assert_nothing_raised(Selenium::WebDriver::Error::TimeOutError, "Error waiting to add to eshelf for url #{@driver.current_url} view #{@view} and tab #{@tab}.") {
          wait.until {
            wait = Selenium::WebDriver::Wait.new(:timeout => 10)
            wait.until { 
              (not @driver.find_elements(:css => "label.tsetse_generated")[index].text.match("^In").nil?)
            }
          }
        }
      end
      
      def wait_for_add_to_eshelf_checkboxes()
        wait = Selenium::WebDriver::Wait.new(:timeout => 10)
        assert_nothing_raised(Selenium::WebDriver::Error::TimeOutError, "Error waiting to add to eshelf for url #{@driver.current_url} view #{@view} and tab #{@tab}.") {
          wait.until {
            wait = Selenium::WebDriver::Wait.new(:timeout => 10)
            wait.until {
              begin
                add_to_eshelf_checkboxes
                true
              rescue Selenium::WebDriver::Error::NoSuchElementError => e
                false
              end
            }
          }
        }
      end
      
      def wait_for_uncheck_add_to_eshelf(index=0)
        wait = Selenium::WebDriver::Wait.new(:timeout => 10)
        assert_nothing_raised(Selenium::WebDriver::Error::TimeOutError, "Error waiting to add to eshelf for url #{@driver.current_url} view #{@view} and tab #{@tab}.") {
          wait.until {
            wait = Selenium::WebDriver::Wait.new(:timeout => 10)
            wait.until { 
              (not @driver.find_elements(:css => "label.tsetse_generated")[index].text.match("^Add").nil?)
            }
          }
        }
      end
        
        # Wait for the eshelf to render.  Generally Primo::Core#click_eshelf_link should be used instead
      def wait_for_eshelf()
        wait = Selenium::WebDriver::Wait.new(:timeout => 10)
        assert_nothing_raised(Selenium::WebDriver::Error::TimeOutError, "Error waiting for eshelf for url #{@driver.current_url} view #{@view} and tab #{@tab}.") {
          wait.until {
            @driver.find_element(:css, "h1").text == "e-Shelf"
          }
        }
      end
    end
  end
end