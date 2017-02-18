require 'fileutils'

module AssertMatchesSnapshot
  module Assertion
    def assert_matches_snapshot(key)
      FileUtils.mkpath(snapshot_file_path)

      full_path = snapshot_file_full_path(key)
      if File.exists?(full_path) && !OverwriteSnapshots.active?
        assert_equal response.body, IO.read(full_path)
      else
        File.open(full_path, 'w') do |snapshot_file|
          snapshot_file.write(response.body)
          snapshot_file.flush
        end
      end
    end

    private

    def snapshot_file_full_path(key)
      File.join(File.expand_path(Dir.pwd), snapshot_file_path, snapshot_file_name(key))
    end

    def snapshot_file_path
      'test/snapshots'
    end

    def snapshot_file_name(key)
      "#{@controller.controller_name}_#{@controller.action_name}_#{key}".downcase.gsub(/\W/, '_') + ".snapshot.html"
    end

    class OverwriteSnapshots
      def self.active?
        ENV['OVERWRITE_SNAPSHOTS'] == 'true'
      end
    end
  end
end
