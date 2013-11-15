=begin rdoc
==Core::Helpers
Basic common functions for testing and/or interacting with NYU libraries pages.

=== User Loops
Perform loops for users.
- Core::Helpers#for_all_consortium_users
- Core::Helpers#for_all_nyu_users

=== Login Actions
Perform basic login functions.
- Core::Helpers#login
- Core::Helpers#login_text
- Core::Helpers#logout
- Core::Helpers#logout_text

=== Waiting
Often it is necessary to wait for a particular event to occur before moving on to 
the next test, especially rendering.
- Core::Helpers#wait_for_login
- Core::Helpers#wait_for_logout

=end

require File.expand_path("#{File.dirname(__FILE__)}/login_helpers")
require File.expand_path("#{File.dirname(__FILE__)}/wait_helpers")
require File.expand_path("#{File.dirname(__FILE__)}/users_helpers")
require File.expand_path("#{File.dirname(__FILE__)}/dynamic_helpers")
require File.expand_path("#{File.dirname(__FILE__)}/navigation_helpers")
require File.expand_path("#{File.dirname(__FILE__)}/time_helpers")
module NyuLibraries
  module Core
    module Helpers
      include LoginHelpers
      include WaitHelpers
      include UsersHelpers
      include DynamicHelpers
      include NavigationHelpers
      include TimeHelpers
    end
  end
end