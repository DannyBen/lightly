class Lightly
  include CacheOperations

  class << self
    include CacheOperations
  end
end
