=begin rdoc
== Home
Tests for TseTse home page.

=end
require File.expand_path("#{File.dirname(__FILE__)}/../test_case")
module NyuLibraries::TseTse::Login
  # Make sure redirects from root TseTse url go to the correct view
  def test_login_and_logout
    @current_test_name = "TseTse - Testing loggin in and out."
    for_all_nyu_users do |user|
      for_each_view do
        next if views_sans_login.include? @view
        login_for_nyu user do
          logged_in_with_proper_user? user
        end
      end
    end
  end
  
  def test_login_and_logout_consortium
    @current_test_name = "TseTse - Testing logging in and out as Consortium"
    for_all_consortium_users do |user|
      for_each_view do
        next if views_sans_login.include? @view
        login_for_consortium user do
          logged_in_with_proper_user? user
        end
      end
    end
  end
  
  def test_login_no_user_consortium
    @current_test_name = "TseTse - Testing logging in with no credentials"
    for_each_view do
      next if views_sans_login.include? @view
      login
      wait_for_nyu_pds_login_form
      nyu_pds_login_form.submit
      wait_for_page_title
      assert is_page_title?("BobCat"), "Should not redirect to another page, for view #{@view} and url #{@driver.current_url}"
    end
  end
end

class TseTseTest < NyuLibraries::TseTse::TestCase
  include NyuLibraries::TseTse::Login
end