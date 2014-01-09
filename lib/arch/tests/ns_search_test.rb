=begin rdoc
== Brief
Tests for Arch brief results page.

=end
require File.expand_path("#{File.dirname(__FILE__)}/../test_case")
module NyuLibraries::Arch::NsSearch
  # Test default search settings for successful search, common elements, facets and results.
  def test_search_from_ns
    @current_test_name = "Arch - Testing search from NS library"
    @view = "NS"
    each_driver do
      navigate_to "http://library.newschool.edu"
      wait_for_page_title
      vtabs5.find_elements(:css, "a.closed").first.click
      vtabs5.find_elements(:id, "queryTerm")[1].send_keys "jack"
      # vtabs5.find_elements(:id, "queryTerm")[1].send_keys :return
      navigate_to("https://login.libproxy.newschool.edu/login?url=https://arch.library.nyu.edu/ns?query=jack&field=WRD&base=metasearch&action=search&context=General%20Research&subject=general-research")
      # @driver.switch_to.window @driver.window_handles.last
      wait_for_user
      user.send_keys @ns_username
      @driver.find_element(:id, "pass").send_keys @ns_password
      @driver.find_element(:id, "pass").send_keys :return
      wait_for_arch
      wait_for_search "jack"
      common_elements?
      facets?
      results?
      arch_title = record_title
      # @driver.find_element(:css, "a.recordAction").click
      navigate_to @driver.find_element(:css, "a.recordAction").attribute("href")
      # @driver.switch_to.window @driver.window_handles.last
      wait_for_page_title
      assert_not_nil(page_title.match("GetIt"), "Looks like GetIt could not be loaded for view: #{@view} and current url #{@driver.current_url}. The page title is #{page_title}")
      assert_not_nil(@driver.current_url.match("umlaut.institution=#{@view}"), "GetIt view is not #{@view} for current url #{@driver.current_url}")
    end
  end
  def test_articles_subjects_from_ns
    @current_test_name = "Arch - Testing article subjects from NS library"
    @view = "NS"
    each_driver do
      navigate_to "http://library.newschool.edu"
      wait_for_page_title
      vtabs5.find_elements(:css, "a.closed").first.click
      Selenium::WebDriver::Support::Select.new(@driver.find_element(:css, "select#queryType")).select_by(:value, "WSU")
      wait_for_arch
      common_elements?
    end
  end
  def test_databases_from_ns
    @current_test_name = "Arch - Testing databases from NS library"
    @view = "NS"
    each_driver do
      navigate_to "http://library.newschool.edu"
      wait_for_page_title
      vtabs5.find_elements(:css, "a.closed")[1].click
      vtabs5.find_elements(:id, "queryTerm")[2].send_keys "a"
      # vtabs5.find_elements(:id, "queryTerm")[2].send_keys :return
      # @driver.switch_to.window @driver.window_handles.last
      navigate_to("https://login.libproxy.newschool.edu/login?url=https://arch.library.nyu.edu/ns/?query=a&base=databases&action=find")
      wait_for_user
      user.send_keys @ns_username
      @driver.find_element(:id, "pass").send_keys @ns_password
      @driver.find_element(:id, "pass").send_keys :return
      wait_for_arch
      wait_for_page_title
      assert(@driver.find_elements(:class, "result").size > 0, "Could not find and databases in #{@driver.current_url}")
    end
  end
end

class ArchTest < NyuLibraries::Arch::TestCase
  # include NyuLibraries::Arch::NsSearch
end