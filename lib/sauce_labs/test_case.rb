require 'minitest/unit'
require 'test/unit'
require 'yaml'
require 'selenium-webdriver'
require 'httparty'
require_relative 'selenium_version'
module SauceLabs
  class TestCase < Test::Unit::TestCase
    @@config_path = File.expand_path("#{File.dirname(__FILE__)}/../../config")
    @@config = {}
    @@config = YAML.load_file("#{@@config_path}/config.yml") if(File.exists?("#{@@config_path}/config.yml"))
    @@config["saucelabsuser"] = ENV["saucelabsuser"] unless @@config.key?("saucelabsuser")
    @@config["saucelabskey"] = ENV["saucelabskey"] unless @@config.key?("saucelabskey")
    @@config["local"] = false unless @@config.key?("local")
    @@sauce_labs_platforms = YAML.load_file("#{@@config_path}/sauce_labs_platforms.yml")
    @@job_ids = {}

    def setup
      @private = false
      @local = @@config["local"]
      @driver = Selenium::WebDriver.for :firefox if @local
      @local = true if @@config["saucelabsuser"].nil? or @@config["saucelabsuser"].nil? unless @local
      @saucelabs = "http://#{@@config["saucelabsuser"]}:#{@@config["saucelabskey"]}@ondemand.saucelabs.com:80/wd/hub"
      @saucelabs_rest = "https://saucelabs.com/rest/v1/#{@@config["saucelabsuser"]}/jobs"
      @capabilities_set = []
      @@sauce_labs_platforms.each_pair do |platform, browsers|
        browsers.each_pair do |browser, versions|
          versions.each {|version| add_capabilities platform, browser, version}
          add_capabilities platform, browser if versions.empty? 
        end
      end
    end
    
    # Overrides MiniTest::Unit#assert to not stop on failures.
    # Theorectically can be used to run through all platforms/browsers,
    # regardless of first failure.
    # Commented out since I'm not sure we actually want this.
    # def assert test, msg
    #   begin
    #     super test, msg
    #   rescue MiniTest::Assertion => e
    #     puts e.message
    #   end
    # end
  
    def teardown
      # puts job_url
      privatize_saucelabs if @private unless @local
      passfail_saucelabs false unless passed? unless @local
      @driver.quit unless @driver.nil?
    end
  
    def pass_saucelabs
      passfail_saucelabs true
    end
  
    def each_driver(&block)
      @@job_ids[@current_test_name] = [] if @@job_ids[@current_test_name].nil?
      if(@local)
        assert_nothing_raised(Timeout::Error, "Driver timed out for url #{@driver.current_url} view #{@view} and tab #{@tab}.") {
          yield @driver
        }
      else
        @capabilities_set.each do |capabilities|
          capabilities[:name] = "#{@current_test_name} #{capabilities[:name]}"
          @driver = Selenium::WebDriver.for(
            :remote,
            :url => "#{@saucelabs}",
            :desired_capabilities => capabilities)
          assert_nothing_raised(Timeout::Error, "Driver timed out for url #{@driver.current_url} view #{@view} and tab #{@tab}.") {
            @job_id = @driver.instance_variable_get(:@bridge).session_id
            @@job_ids[@current_test_name] << @job_id
            yield @driver
            pass_saucelabs
          }
          @driver.quit
        end
      end
    end
    
    def clear_cookies()
      @driver.manage.delete_all_cookies
    end
  
    private
    def job_url
      "https://saucelabs.com/tests/#{@job_id}"
    end
    
    def passfail_saucelabs(passfail)
      HTTParty.put("#{@saucelabs_rest}/#{@job_id}", :basic_auth => {:username => @@config["saucelabsuser"], :password => @@config["saucelabskey"]}, :body => "{\"passed\": #{passfail}}") unless @job_id.nil? or passed?
    end
  
    def privatize_saucelabs()
      HTTParty.put("#{@saucelabs_rest}/#{@job_id}", :basic_auth => {:username => @@config["saucelabsuser"], :password => @@config["saucelabskey"]}, :body => "{\"public\": false") unless @job_id.nil? or passed?
    end
  
    def add_capabilities(platform, browser, version=nil)
      capabilities = 
        Selenium::WebDriver::Remote::Capabilities.send(browser.to_sym)
      capabilities.version = version unless version.nil?
      capabilities.platform = platform.to_sym
      # Sauce Labs Tests should be public unless specifically restricted.
      capabilities[:public] = true
      # Show the BobCat URL being used in this test
      capabilities["custom-data"] = custom_data
      # Set the Selenium Version
      capabilities["selenium-version"] = SauceLabs::SELENIUM_VERSION
      # Timeout after 60 seconds
      capabilities["command-timeout"] = 60
      capabilities["idle-timeout"] = 60
      # Proxy settings dont' currently work effectively for the
      # current version of the gem.
      # capabilities["proxy"] = {'proxyType' => :direct}
      capabilities[:name] = "(#{browser} #{version} on #{platform})"
      @capabilities_set << capabilities
    end
    
    # Return a string of hash of custom data
    def custom_data
      {"BobCat URL" => @bobcat}.keep_if{|k,v| v}
    end
  end
end