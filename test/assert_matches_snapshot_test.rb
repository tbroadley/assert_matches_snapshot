require 'minitest/autorun'
require 'fakefs/safe'

require 'assert_matches_snapshot/assertion'

include AssertMatchesSnapshot::Assertion

class AssertMatchesSnapshotTest < Minitest::Test
  def setup
    @controller = Controller.new('controller_name', 'action_name')
    @response_body = '<p>Hello world</p>'
  end

  def teardown
    FakeFS::FileSystem.clear
  end

  def test_that_snapshot_file_name_returns_correct_name
    assert_equal 'controller_name_action_name_key.snapshot.html', snapshot_file_name('key')
  end

  def test_that_snapshot_file_name_lowercases_all_properties
    @controller_name = 'Controller_Name'
    @action_name = 'aCtIoN_nAmE'
    assert_equal 'controller_name_action_name_key.snapshot.html', snapshot_file_name('kEy')
  end

  def test_that_snapshot_file_name_replaces_non_word_characters_with_underscore
    @controller_name = 'controller*name'
    @action_name = 'action-name'
    assert_equal 'controller_name_action_name_ke_y.snapshot.html', snapshot_file_name('ke\'y')
  end

  def test_that_snapshot_file_full_path_returns_correct_path
    FakeFS do
      result = File.join(
        File.expand_path(Dir.pwd),
        'test',
        'snapshots',
        'controller_name_action_name_key.snapshot.html'
      )
      assert_equal result, snapshot_file_full_path('key')
    end
  end

  def test_that_assert_matches_snapshot_writes_snapshot_to_file
    FakeFS do
      refute File.exist?(snapshot_file_full_path('key'))
      assert_matches_snapshot('key')
      assert File.exist?(snapshot_file_full_path('key'))
      assert_equal response.body, File.read(snapshot_file_full_path('key'))
    end
  end

  def test_that_assert_matches_snapshot_overwrites_existing_snapshot_if_argument_is_passed
    FakeFS do
      OverwriteSnapshots.stub :active?, false do
        refute File.exist?(snapshot_file_full_path('key'))
        assert_matches_snapshot('key')
        assert File.exist?(snapshot_file_full_path('key'))
      end

      OverwriteSnapshots.stub :active?, true do
        @response_body = '<p>Good afternoon world</p>'
        assert_matches_snapshot('key')
        assert_equal response.body, File.read(snapshot_file_full_path('key'))
      end
    end
  end

  private

  def response
    Response.new(@response_body)
  end

  class Controller
    def initialize(controller_name, action_name)
      @controller_name = controller_name
      @action_name = action_name
    end

    def controller_name
      @controller_name
    end

    def action_name
      @action_name
    end
  end

  class Response
    def initialize(body)
      @body = body
    end

    def body
      @body
    end
  end
end
