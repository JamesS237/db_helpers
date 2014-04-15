require 'bloomfilter-rb'

class Bloom
  def initialize(redis, options = {})
    options.reverse_update(counting => false,
                           size => 100,
                           hashes => 2,
                           seed => 1,
                           bucket => 3,
                           r => false,
                           ttl => 2,
                           db => redis)
    @bf = BloomFilter::Redis.new(*options) unless counting
    @bf = BloomFilter::CountingRedis.new(*options) if counting
  end

  def insert(obj)
    @bf.insert(obj)
  end

  def delete(obj)
    @bf.delete(obj)
  end

  def includes?(obj)
    @bf.include(obj)
  end

  def stats
    @bf.stats
  end
end
