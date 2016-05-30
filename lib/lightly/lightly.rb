require 'digest/md5'
require 'fileutils'

class Lightly
  attr_accessor :dir, :life, :hash

  def initialize(opts={})
    @dir = opts[:dir] || 'cache'
    @life = opts[:life] || 3600
    @hash = opts.key?(:hash) ? opts[:hash] : true
    @enabled = true
  end

  def get(key, &block)
    return load key if cached?(key) && enabled?

    content = block.call
    save key, content if enabled?
    content
  end

  def flush
    return false if dir == '/' || dir.empty?
    FileUtils.rm_rf dir
  end

  def enabled?
    @enabled
  end

  def cached?(key)
    path = get_path key
    File.exist?(path) and !expired?(path)
  end

  def enable
    @enabled = true
  end

  def disable
    @enabled = false
  end

  private

  def save(key, content)
    FileUtils.mkdir_p dir
    path = get_path key
    File.open path, 'wb' do |f| 
      f.write Marshal.dump content
    end
  end

  def load(key)
    Marshal.load File.binread(get_path key)
  end

  def get_path(key)
    key = Digest::MD5.hexdigest(key) if hash
    File.join dir, key
  end

  def expired?(path)
    expired = life > 0 && File.exist?(path) && Time.new - File.mtime(path) >= life
    FileUtils.rm path if expired
    expired
  end
end
