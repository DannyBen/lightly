Lightly - Ruby File Cache
==================================================

[![Gem](https://img.shields.io/gem/v/lightly.svg?style=flat-square)](https://rubygems.org/gems/lightly)
[![Travis](https://img.shields.io/travis/DannyBen/lightly.svg?style=flat-square)](https://travis-ci.org/DannyBen/lightly)
[![Code Climate](https://img.shields.io/codeclimate/github/DannyBen/lightly.svg?style=flat-square)](https://codeclimate.com/github/DannyBen/lightly)
[![Gemnasium](https://img.shields.io/gemnasium/DannyBen/lightly.svg?style=flat-square)](https://gemnasium.com/DannyBen/lightly)

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
lightly.life = 7200 # seconds
lightly.hash = false
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

---

For a similar gem that provides caching specifically for HTTP downloads,
see the [WebCache gem][1]


[1]: https://github.com/DannyBen/webcache