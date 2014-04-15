require 'bloomfilter-rb'

# This class creates either a native or redis based
# bloom filter.

class Bloom
  def initialize(redis, options = {})
    options = { 'native' => options['native'] || false,
                'size' => options['size'] || 100,
                'hashes' => options['hashes'] || 2,
                'seed' => options['seed'] || 1,
                'bucket' => options['bucket'] || 3,
                'raise' => options['raise'] || false,
                'ttl' => options['ttl'] || 2,
                'db' => redis }

    @bf = BloomFilter::CountingRedis.new(options) unless options['native']
    @bf = BloomFilter::Native.new(options) if options['native']
  end

  def insert(obj)
    @bf.insert(obj)
  end

  def delete(obj)
    @bf.delete(obj)
  end

  def includes?(obj)
    @bf.include?(obj)
  end

  def stats
    @bf.stats
  end
end
