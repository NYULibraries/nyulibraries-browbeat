module NyuLibraries
  module TseTse
    module Helpers
      def self.included(klass)
        klass.send :attr_reader, :views, :xpaths, :reserves_tabs, :views_sans_eshelf, :views_sans_access, :views_sans_login, :users
      end
      
      def for_each_view(&block)
        views.each_pair do |view, values|
          @view = view
          values["redirects"].each do |redirect|
            navigate_to "#{@tsetse}?institution=#{redirect}"
            yield redirect
          end
        end
      end
      
      def common_elements?
        assert nav1?
        assert header?
        assert hd_link_to_home?
        assert maincontent?
        assert content_for_layout?
      end
    end
  end
end