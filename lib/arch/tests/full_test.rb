=begin rdoc
== Full
Tests for Arch full details page.

=end
require File.expand_path("#{File.dirname(__FILE__)}/../test_case")
module NyuLibraries::Arch::Full
  # Test full details page for common elements
  def test_full
    @current_test_name = "Arch - Testing Full Details Display"
    for_all_nyu_users do |user|
      each_view_default_searches do |search_term|
        next if views_sans_access.include?(@view)
        login_for_nyu user do
          # Search Primo
          submit_search search_term
          # Click first link
          click_details_link
          # Make sure the common elements are there
          common_elements?
        end
      end
    end
  end
end

class ArchTest < NyuLibraries::Arch::TestCase
  # include NyuLibraries::Arch::Full
end