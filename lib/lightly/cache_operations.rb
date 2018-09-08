require 'digest/md5'
require 'fileutils'

class Lightly
  module CacheOperations
    attr_writer :dir, :hash

    def initialize(dir: 'cache', life: '1h', hash: true, enabled: true)
      @dir = dir
      @life = life_to_seconds life
      @hash = hash
      @enabled = enabled
    end

    def get(key, &block)
      return load key if cached?(key) && enabled?

      content = block.call
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

    def cached?(key)
      path = get_path key
      File.exist?(path) and File.size(path) > 0 and !expired?(path)
    end

    def enable
      @enabled = true
    end

    def disable
      @enabled = false
    end

    def get_path(key)
      key = Digest::MD5.hexdigest(key) if hash
      File.join dir, key
    end

    def save(key, content)
      FileUtils.mkdir_p dir
      path = get_path key
      File.open path, 'wb' do |f| 
        f.write Marshal.dump content
      end
    end
    
    private

    def load(key)
      Marshal.load File.binread(get_path key)
    end

    def expired?(path)
      expired = life > 0 && File.exist?(path) && Time.new - File.mtime(path) >= life
      FileUtils.rm path if expired
      expired
    end

    def life_to_seconds(arg)
      arg = arg.to_s

      case arg[-1]
      when 's'; arg[0..-1].to_i
      when 'm'; arg[0..-1].to_i * 60
      when 'h'; arg[0..-1].to_i * 60 * 60
      when 'd'; arg[0..-1].to_i * 60 * 60 * 24
      else;     arg.to_i
      end
    end

  end
end
