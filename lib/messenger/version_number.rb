require 'yaml'

module Messenger
  class VersionNumber

    def initialize
      @version = YAML.load_file('VERSION.yml')
    end

    def major
      @version['major']
    end

    def minor
      @version['minor']
    end

    def patch
      @version['patch']
    end

    def to_hash
      @version.dup
    end

    def to_a
      [major, minor, patch]
    end

    def to_s
      to_a.join(".")
    end

  end
end
