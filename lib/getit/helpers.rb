module NyuLibraries
  module GetIt
    module Helpers
      def self.included(klass)
        klass.send :attr_reader, :views, :xpaths, :reserves_tabs, :views_sans_eshelf, :views_sans_access, :views_sans_login, :users
      end
      
      class GetItResult
        def initialize(element)
          @title = element.find_element(:class, "title")
          @issn = element.find_elements(:class, "issn").first
          @delivery = element.find_element(:class, "delivery")
          @content_type = element.find_element(:tag_name, "figcaption")
        end
        
        def title
          @title.text
        end
        
        def issn
          @issn.text
        end
        
        def delivery
          @delivery.text
        end
        
        def content_type
          @content_type.text
        end
        
        def click
          @title.find_element(:tag_name, "a").click
        end
      end
  
      # Loop through each redirect for each view.
      def for_each_view(&block)
        views.each_pair do |view, values|
          @view = view
          values["redirects"].each do |redirect|
            navigate_to "#{@getit}/#{redirect}"
            assert_not_nil @driver.manage.cookie_named("_getit_session"), "No GetIt Session established."
            yield redirect
          end
        end
      end
      
      def title_search_type
        @driver.find_element(:name, "umlaut.title_search_type")
      end
      
      def for_each_default_precision_title_search(&block)
        wait_for_title_search_type
        default_precision = views[@view]["default_precision"]
        search_term = views[@view]["searches"][default_precision]
        Selenium::WebDriver::Support::Select.new(title_search_type).select_by(:value, default_precision)
        title_search search_term
        yield search_term
      end
      
      def set_precision_search(precision,&block)
        wait_for_title_search_type
        Selenium::WebDriver::Support::Select.new(title_search_type).select_by(:value, precision)
        title_search views[@view]["searches"][precision]
        yield views[@view]["searches"][precision]
      end
      
      def each_view_contains_search(&block)
        views[@view]["searches"].each do |searches|
          title_search searches["contains"]
          yield searches["contains"]
        end
      end
      
      def each_view_exact_search(&block)
        set_precision_search "exact", &block
      end
      
      def each_view_starts_with_search(&block)
        views[@view]["searches"].each do |searches|
          title_search searches["starts_with"]
          yield searches["starts_with"]
        end
      end
      
      def title_search(title)
        wait_for_journal_title
        journal_title.send_keys title
        search_form.submit
      end
      
      def results_list()
        wait_for_element_by_class "result"
        results = []
        @driver.find_elements(:class, "result").each do |result|
          results << GetItResult.new(result)
        end
        results
      end
      
      def result(index=0)
        results[index]
      end
      
      def results?
        assert( results_list.size <= 20, "Results list was not less than or equal to 20 in #{@view} and url #{@driver.current_url}")
      end
      
      def common_elements?()
        assert_not_nil(@driver, "Driver is nill for view #{@view} and url #{@driver.current_url}.")
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
      
      def header?()
        # Is the header div present?
        assert_equal("header", header.tag_name.downcase, "Tag name of header element is not 'div' for view #{@view} and url #{@driver.current_url}.")
        bobcat_spans = header.find_elements(:tag_name, "span")
        assert_equal(3, bobcat_spans.size(), "Header spans return an unexpected size for view #{@view} and url #{@driver.current_url}.")
        bobcat_spans.each do |span|
          # The header spans are hidden
          assert_equal("", span.text, "Header span is not hidden for view #{@view} and url #{@driver.current_url}.")
        end
      end
      
      def nav1?()
        # Is the nav1 div present?
        assert_equal("nav", nav1.tag_name.downcase, "Tag name of nav1 element is not 'div' for view #{@view} and url #{@driver.current_url}.")
        assert_equal("ul", nav1.find_element(:class, "nyu-breadcrumbs").tag_name.downcase, "Tag name of left nav1 list element is not 'ul' for view #{@view} and url #{@driver.current_url}.")
        assert_equal("ul", nav1.find_element(:class, "nyu-login").tag_name.downcase, "Tag name of right nav1 list element is not 'ul' for view #{@view} and url #{@driver.current_url}.")
      end

      def sidebar_boxes()
        sidebar.find_elements(:class, "navbar")
      end
      

      def sidebar?()
        # Is the sidebar div present?
        assert_equal("div", sidebar.tag_name.downcase, "Tag name of sidebar element is not 'div' for view #{@view} and url #{@driver.current_url}.")
        assert((not sidebar_boxes.empty?), "Sidebar boxes are empty for view #{@view} and url #{@driver.current_url}.")
      end
      
      def search_form()
        @driver.find_element(:id, "OpenURL")
      end
      
      def search_container()
        @driver.find_element(:class, "search")
      end

      def search?()
        # Is the search_container div present?
        assert_equal("div", search_container.tag_name.downcase, "Tag name of search container element is not 'div' for view #{@view} and url #{@driver.current_url}.")
        tabs?
        assert_equal("form", search_form.tag_name.downcase, "Tag name of search form element is not 'form' for view #{@view} and url #{@driver.current_url}.")
      end
      
      def tabs()
        @driver.find_element(:class, "nav-tabs")
      end
      
      def tabs?()
        assert_equal("ul", tabs.tag_name.downcase, "Tag name of tabs element is not 'div' for view #{@view} and url #{@driver.current_url}.")
        assert((not tabs.find_elements(:tag_name, "li").empty?), "Tabs are empty for view #{@view} and url #{@driver.current_url}.")
      end
      
      def footer()
        @driver.find_element(:tag_name, "footer")
      end

      def footer?()
        assert_not_nil(footer.text.match("NYU Division of Libraries"), "Footer text is unexpected for view #{@view} and url #{@driver.current_url}.")
      end
    end
  end
end