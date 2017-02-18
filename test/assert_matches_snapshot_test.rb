require 'minitest/autorun'
require 'fakefs/safe'

require 'assert_matches_snapshot/assertion'

include AssertMatchesSnapshot::Assertion

class AssertMatchesSnapshotTest < Minitest::Test
  def test_that_snapshot_file_name_returns_correct_name
    assert_equal 'controller_name_action_name_key.snapshot.html', snapshot_file_name('key')
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

  private

  def controller_name
    'controller_name'
  end

  def action_name
    'action_name'
  end

  def response
    Response.new(response_body)
  end

  def response_body
    '<p>Hello world</p>'
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
