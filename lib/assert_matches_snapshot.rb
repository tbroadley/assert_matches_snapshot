require 'active_support/lazy_load_hooks'
require 'assert_matches_snapshot/assertion'

ActiveSupport.on_load(:action_controller) do
  ActionController::TestCase.send(:include, AssertMatchesSnapshot::Assertion)
  ActionDispatch::IntegrationTest.send(:include, AssertMatchesSnapshot::Assertion)
end
