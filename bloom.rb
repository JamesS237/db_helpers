require 'bloomfilter-rb'

#== Bloom
#
#    redis = Redis.new # create a Redis connection
#    bf = Bloom.new redis # returns a new Bloom instance
#
class Bloom
  def initialize(redis, options = {})
    #merge options with defaults
    options = { 'native' => options['native'] || false,
                'size' => options['size'] || 100,
                'hashes' => options['hashes'] || 2,
                'seed' => options['seed'] || 1,
                'bucket' => options['bucket'] || 3,
                'raise' => options['raise'] || false,
                'ttl' => options['ttl'] || 2,
                'db' => redis }

    # either use native implementation or redis backed
    @bf = BloomFilter::CountingRedis.new(options) unless options['native']
    @bf = BloomFilter::Native.new(options) if options['native']
  end

  #== Insert
  #
  #    redis = Redis.new # create a Redis connection
  #    bf = Bloom.new redis # returns a new Bloom instance
  #    bf.insert("foo") # insert `foo` into the bloom filter
  #
  def insert(obj)
    @bf.insert(obj)
  end

  #== Delete
  #
  #    redis = Redis.new # create a Redis connection
  #    bf = Bloom.new redis # returns a new Bloom instance
  #    bf.delete("foo") # delete `foo` from the bloom filter
  #
  def delete(obj)
    @bf.delete(obj)
  end

  #== Includes
  #
  #    redis = Redis.new # create a Redis connection
  #    bf = Bloom.new redis # returns a new Bloom instance
  #    bf.includes?("foo") # does bloom filter include `foo`?
  #
  def includes?(obj)
    @bf.include?(obj)
  end

  #== Stats
  #
  #    redis = Redis.new # create a Redis connection
  #    bf = Bloom.new redis # returns a new Bloom instance
  #    bf.stats # prints stats
  #
  def stats
    @bf.stats
  end
end
