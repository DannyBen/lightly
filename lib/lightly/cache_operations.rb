require 'digest/md5'
require 'fileutils'

class Lightly
  module CacheOperations
    attr_accessor :permissions
    attr_writer :dir, :hash

    def initialize(dir: 'cache', life: '1h', hash: true, enabled: true, permissions: nil)
      @dir = dir
      @life = life_to_seconds life
      @hash = hash
      @enabled = enabled
      @permissions = permissions
    end

    def get(key)
      return load key if cached?(key) && enabled?

      content = yield
      save key, content if content && enabled?
      content
    end

    def life
      @life ||= 3600
    end

    def life=(new_life)
      @life = life_to_seconds new_life
    end

    def dir
      @dir ||= 'cache'
    end

    def hash?
      @hash ||= (@hash.nil? ? true : @hash)
    end

    def enabled?
      @enabled ||= (@enabled.nil? ? true : @enabled)
    end

    def clear(key)
      path = get_path key
      FileUtils.rm path if File.exist? path
    end

    def flush
      return false if dir == '/' || dir.empty?

      FileUtils.rm_rf dir
    end

    def prune
      return false if dir == '/' || dir.empty?

      Dir["#{dir}/*"].each { |file| expired? file }
    end

    def cached?(key)
      path = get_path key
      File.exist?(path) and File.size(path).positive? and !expired?(path)
    end

    def enable
      @enabled = true
    end

    def disable
      @enabled = false
    end

    def get_path(key)
      key = Digest::MD5.hexdigest(key) if hash?
      File.join dir, key
    end

    def save(key, content)
      FileUtils.mkdir_p dir
      path = get_path key
      File.open path, 'wb', permissions do |file|
        file.write Marshal.dump(content)
      end
    end

  private

    def load(key)
      Marshal.load File.binread(get_path key)
    end

    def expired?(path)
      expired = life >= 0 && File.exist?(path) && Time.now - File.mtime(path) >= life
      FileUtils.rm path if expired
      expired
    end

    def life_to_seconds(arg)
      arg = arg.to_s

      case arg[-1]
      when 's' then arg[0..].to_i
      when 'm' then arg[0..].to_i * 60
      when 'h' then arg[0..].to_i * 60 * 60
      when 'd' then arg[0..].to_i * 60 * 60 * 24
      else
        arg.to_i
      end
    end
  end
end
