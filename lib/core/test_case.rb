require File.expand_path("#{File.dirname(__FILE__)}/../sauce_labs/test_case")
require File.expand_path("#{File.dirname(__FILE__)}/helpers")
module NyuLibraries
  module Core
    class TestCase < SauceLabs::TestCase
      @@config["email1"] = ENV["email1"] unless @@config.key?("email1")
      @@config["email2"] = ENV["email2"] unless @@config.key?("email2")
      @@config["campus"] = ENV["campus"] unless @@config.key?("campus")
      @@config["nyu_home"] = ENV["nyu_home"] unless @@config.key?("nyu_home")
      @@config["nyu_username"] = ENV["nyu_username"] unless @@config.key?("nyu_username")
      @@config["nyu_password"] = ENV["nyu_password"] unless @@config.key?("nyu_password")
      @@config["nyu_firstname"] = ENV["nyu_firstname"] unless @@config.key?("nyu_firstname")
      @@config["consortium_username"] = ENV["consortium_username"] unless @@config.key?("consortium_username")
      @@config["consortium_password"] = ENV["consortium_password"] unless @@config.key?("consortium_password")
      @@config["consortium_firstname"] = ENV["consortium_firstname"] unless @@config.key?("consortium_firstname")
      include Core::Helpers
    
      def setup
        super
        # Default driver is firefox.
        @nyu_home = @@config["nyu_home"]
        @email1 = @@config["email1"]
        @email2 = @@config["email2"]
        @cookies = %w(_tsetse_session tsetse_credentials tsetse_handle nyulibrary_opensso_illiad
          _umlaut_session _getit_session _eshelf_session _umbra_session _privileges_guide_session
            _room_reservation_session _room_reservation_session _marli_session xerxessession_)
        @users = [
          { :username => @@config["consortium_username"], 
            :password => @@config["consortium_password"], 
            :wayf => :consortium,
            :firstname => @@config["consortium_firstname"]},
          { :username => @@config["nyu_username"], 
            :password => @@config["nyu_password"], 
            :wayf => :nyu,
            :firstname => @@config["nyu_firstname"]}]
      end
    end
  end
end