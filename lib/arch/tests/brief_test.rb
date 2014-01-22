=begin rdoc
== Brief
Tests for Arch brief results page.

=end
require File.expand_path("#{File.dirname(__FILE__)}/../test_case")
module NyuLibraries::Arch::Brief
  # Test default search settings for successful search, common elements, facets and results.
  def test_brief_all_fields
    @current_test_name = "Arch - Testing Brief Results Display on Arch"
    for_all_nyu_users do |user|
      each_view_default_searches do |search_term|
        next if views_sans_access.include?(@view)
        login_for_nyu user do
          wait_for_search_field
          submit_search search_term
          common_elements?
          facets?
          results?
        end
      end
    end
  end
  
  # Test 'title' search for successful search, common elements, facets and results.
  def test_brief_title
    @current_test_name = "Arch - Testing Brief Results Display on Arch with scope set to title"
    for_all_nyu_users do |user|
      each_view_default_searches do |search_term|
        next if views_sans_access.include?(@view)
        login_for_nyu user do
          # Set the scope to 'title'
          set_scope1 "WTI"
          # Search Arch
          submit_search search_term
          # Make sure the common elements are there
          common_elements?
          # Check that facets are present
          facets?
          # Check that results are present
          results?
          assert_not_nil(record_title.downcase.match(search_term), "Arch title '#{record_title}' doesn't match search term '#{search_term}' for view #{@view} and tab #{@tab}.")
        end
      end
    end
  end
  
  # Test 'author' search with scope limited to title for successful search, common elements, facets, results and accuracy of results.
  def test_brief_author
      @current_test_name = "Arch - Testing Brief Results Display with scope set to author"
      for_all_nyu_users do |user|
        each_view_default_searches do |search_term|
          next if views_sans_access.include?(@view)
          login_for_nyu user do
            # Set scope 1 to author
            set_scope1 "WAU"
            # Search Arch
            submit_search search_term
            # Make sure the common elements are there
            common_elements?
            # Check that facets are present
            facets?
            # Check that results are present
            results?
          end
        end
      end
    end
  
  # Test 'subject' search for successful search, common elements, facets, results and accuracy of results.
  def test_brief_subject
    @current_test_name = "Arch - Testing Brief Results Display with scope set to subject"
    for_all_nyu_users do |user|
      each_view_default_searches do |search_term|
        next if views_sans_access.include?(@view)
        login_for_nyu user do
          # Set the scope to subject
          set_scope1 "WSU"
          # Search Arch
          submit_search search_term
          # Make sure the common elements are there
          common_elements?
          # Check that facets are present
          facets?
          # Check that results are present
          results?
        end
      end
    end
  end
end

class ArchTest < NyuLibraries::Arch::TestCase
  # include NyuLibraries::Arch::Brief
end