require 'bloomfilter-rb'

class Bloom
  def initialize(redis, counting=false, size=100, hashes=2, seed=1, bucket=3, r=false)
    if counting
      @bf = BloomFilter::CountingRedis.new(:size => size, :hashes => hashes, :seed => seed, :bucket => bucket, :raise => r, :db => redis, :ttl => 2)
    else
      @bf = BloomFilter::Redis.new(:size => size, :hashes => hashes, :seed => seed, :bucket => bucket, :raise => r, :db => redis)
    end
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
