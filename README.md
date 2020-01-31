Lightly - Ruby File Cache
==================================================

[![Gem Version](https://badge.fury.io/rb/lightly.svg)](https://badge.fury.io/rb/lightly)
[![Build Status](https://github.com/DannyBen/lightly/workflows/Test/badge.svg)](https://github.com/DannyBen/lightly/actions?query=workflow%3ATest)
[![Maintainability](https://api.codeclimate.com/v1/badges/8296395c9a332a15afc7/maintainability)](https://codeclimate.com/github/DannyBen/lightly/maintainability)

---

Lightly is a file cache for performing heavy tasks, lightly.

---

Install
--------------------------------------------------

```
$ gem install lightly
```

Or with bundler:

```ruby
gem 'lightly'
```

Usage
--------------------------------------------------

Lightly can be used both as an instance, and as a static class.

```ruby
require 'lightly'

# Instance
cache = Lightly.new life: '3h'
response = cache.get 'key' do
  # Heavy operation here
end

# Static
Lightly.life = '3h'
Lightly.get 'key' do
  # Heavy operation here
end
```

The design intention is to provide both a globally available singleton
`Lightly` object, as well as multiple caching instances, with different
settings - depending on the use case.

Note that the examples in this README are all using the instance syntax, but
all methods are also available statically.

This is the basic usage pattern:

```ruby
require 'lightly'

lightly = Lightly.new

content = lightly.get 'key' do
  # Heavy operation here
  entire_internet.download
end
```

This will look for a cached object with the given key and return it 
if it exists and not older than 1 hour. Otherwise, it will perform the
operation inside the block, and save it to the cache object.

By default, the cached objects are stored in the `./cache` directory, and
expire after 60 minutes. The cache directory will be created as needed.

In addition, the provided key is hashed to its MD5 representation.

You can change these settings on initialization:

```ruby
lightly = Lightly.new dir: 'tmp/my_cache', life: 7200, hash: false
```

Or later:

```ruby
lightly = Lightly.new
lightly.dir = 'tmp/my_cache'
lightly.life = '1d'
lightly.hash = false
```

The `life` property accepts any of these formats:

```ruby
cache.life = 10     # 10 seconds
cache.life = '20s'  # 20 seconds
cache.life = '10m'  # 10 minutes
cache.life = '10h'  # 10 hours
cache.life = '10d'  # 10 days
```

To check if a key is cached, use the `cached?` method:

```ruby
lightly = Lightly.new
lightly.cached? 'example'
# => false

content = lightly.get 'example' do
  open('http://example.com').read
end

lightly.cached? 'example'
# => true
```

You can enable/disable the cache at any time:

```ruby
lightly = Lightly.new
lightly.disable
lightly.enabled? 
# => false

content = lightly.get 'example' do
  open('http://example.com').read
end

lightly.cached? 'example'
# => false

lightly.enable

content = lightly.get 'example' do
  open('http://example.com').read
end

lightly.cached? 'example'
# => true
```

To flush the cache, call:

```ruby
lightly = Lightly.new
lightly.flush
```

To clear the cache for a given key, call:

```ruby
lightly = Lightly.new
lightly.clear 'example'
```

To clear all expired keys, call:

```ruby
lightly = Lightly.new
lightly.prune
```

If your block returns false or nil, the data will not be cached:

```ruby
result = cache.get 'test' do
  false
end

puts cache.cached? 'test'
# => false
```

---

For a similar gem that provides caching specifically for HTTP downloads,
see the [WebCache gem][1]


[1]: https://github.com/DannyBen/webcache
