=begin rdoc
== Full
Tests for Arch add to eshelf.

=end
require File.expand_path("#{File.dirname(__FILE__)}/../test_case")
module NyuLibraries::Primo
  module Eshelf
    module MyAccount
      def test_eshelf_my_account
        @current_test_name = "Primo - Testing 'my account' in eshelf"
        for_all_nyu_users do |user|
          each_view_tab do
            next if views_sans_eshelf.include?(@view)
            next if views_sans_login.include?(@view)
            login_for_nyu user do
              come_back_after do
                click_eshelf_link
                wait_for_eshelf
                wait_for_sidebar
                sidebar_box_by_id("shelf").find_element(:id, "account").click
                assert_nothing_raised "Cannot find eshelf iframe for view #{@view} and tab #{@tab} and url #{@driver.current_url}." do
                  @driver.switch_to.frame "aleph_account"
                end
                assert_nothing_raised "Cannot find firstname for view #{@view} and tab #{@tab} and url #{@driver.current_url}." do
                  assert_equal "#{user[:firstname]}".downcase, @driver.find_element(:tag_name, 'h3').text.split(',').last.downcase, "First names do not match!"
                end
                @driver.switch_to.default_content;
              end
            end
          end
        end
      end
    end
  end
end

class PrimoTest < NyuLibraries::Primo::TestCase
  # include NyuLibraries::Primo::Eshelf::MyAccount
end