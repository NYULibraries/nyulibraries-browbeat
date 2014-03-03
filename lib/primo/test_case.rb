require File.expand_path("#{File.dirname(__FILE__)}/../core/test_case")
require File.expand_path("#{File.dirname(__FILE__)}/helpers")
module NyuLibraries
  module Primo
    # Base class for BobCat Testss
    class TestCase < NyuLibraries::Core::TestCase
      @@views = YAML.load_file("#{@@config_path}/primo_views.yml")
      @@config["bobcat"] = ENV["bobcat"] unless @@config.key?("bobcat")
      include Primo::Helpers

      def setup
        super
        @view = "NYU"
        @tab = "all"
        @bobcat = @@config["bobcat"]
        @context = @@config["bobcat_context"] || "default"
        @search_url = "#{@bobcat}/primo_library/libweb/action/search.do"
        @email1 = @@config["email1"]
        @email2 = @@config["email2"]
        @views = @@views
        @xpaths = {
          :send_share => '//*[@class="save_list"]/li[1]/span/button/span[text()="Send/Share"]',
          :email_link => '//*[@class="save_list"]/li[1]/span/ul/li/a[text()="E-mail"]',
          :print_link => '//*[@class="save_list"]/li[1]/span/ul/li/a[text()="Print"]',
          :email_link => '//*[@class="save_list"]/li[1]/span/ul/li/a[text()="E-mail"]',
        }
        @reserves_tabs = ["reserves", "nscr", "cucr", "nyuadcr"]
        @views_sans_eshelf = ["NYHS"]
        @views_sans_login = ["NYHS", "BHS"]
      end
    end
  end
end