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

module NyuLibraries
  module Core
    module Helpers
      module UsersHelpers
        # Accessor for all NYU users.
        def nyu_users
          @nyu_users ||= @users.keep_if { |user| user[:wayf] != :consortium }
        end
        
        # Accessor for all consortium users.
        def consortium_users
          @consortium_user ||= @users.keep_if { |user| user[:wayf].eql? :consortium }
        end
        
        # A loop for all NYU users on each driver.
        def for_all_nyu_users(&block)
          each_driver do
            nyu_users.each do |user|
              yield user
            end
          end
        end
        
        # A loop for all consortium users on each driver.
        def for_all_consortium_users(&block)
          each_driver do
            consortium_users.each do |user|
              yield user
            end
          end
        end
      end
    end
  end
end