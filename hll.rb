require 'hyperloglog-redis'

#== HyperLog
#
#    redis = Redis.new # create a Redis connection
#    hl = HyperLog.new redis # returns a new HyperLog instance
#
class HyperLog
  def initialize(redis)
    @counter = HyperLogLog::Counter.new(redis)
  end

  #== Create
  #
  #    redis = Redis.new # create a Redis connection
  #    hl = HyperLog.new redis # returns a new HyperLog instance
  #    hl.create('cliche', ['foo', 'bar', 'baz', 'hello world']) # create a hyperlog array called `cliche` in redis, containing `foo`, `bar`, `baz` and `hello world`
  #
  def create(name, array)
    array.each do |i|
      @counter.add(name, i)
    end
  end

  #== Add
  #
  #    redis = Redis.new # create a Redis connection
  #    hl = HyperLog.new redis # returns a new HyperLog instance
  #    hl.create('cliche', ['foo', 'bar'])
  #
  #    hl.add('cliche', 'baz') # add `baz` to the hyperlog array `cliche`
  #    hl.add('cliche', ['hello', 'world']) # add `hello` and `world` to the hyperlog array `cliche`
  #
  def add(name, items)
    if items.is_a?(Array)
      items.each do |i|
        @counter.add(name, i)
      end
    else
      @counter.add(name, items)
    end
  end

  #== Count
  #
  #    redis = Redis.new # create a Redis connection
  #    hl = HyperLog.new redis # returns a new HyperLog instance
  #    hl.create('cliche', ['foo', 'bar'])
  #
  #    hl.count('cliche') # estimated count of items in the set
  #
  def count(name)
    @counter.count(name)
  end

  #== Union
  #
  #    redis = Redis.new # create a Redis connection
  #    hl = HyperLog.new redis # returns a new HyperLog instance
  #    hl.create('cliche', ['foo', 'bar'])
  #    hl.create('eyy', ['bar', 'baz'])
  #
  #    hl.union(['cliche', 'eyy']) # intersect the sets `eyy` and `cliche`
  #
  def union(sets)
    @counter.union(sets)
  end

  #== Union
  #
  #    redis = Redis.new # create a Redis connection
  #    hl = HyperLog.new redis # returns a new HyperLog instance
  #    hl.create('cliche', ['foo', 'bar'])
  #    hl.create('eyy', ['bar', 'baz'])
  #
  #    hl.union_store(['cliche', 'eyy'], 'sweet') # intersect the sets `eyy` and `cliche`, and store the result in the set `sweet`
  #
  def union_store(sets, out)
    @counter.union_store(name, out)
  end

  #== Intersect
  #
  #    redis = Redis.new # create a Redis connection
  #    hl = HyperLog.new redis # returns a new HyperLog instance
  #    hl.create('cliche', ['foo', 'bar'])
  #    hl.create('eyy', ['bar', 'baz'])
  #
  #    hl.intersect(['cliche', 'eyy']) # intersect the sets `eyy` and `cliche`
  #
  def intersect(sets)
    @counter.intersection(sets)
  end
end
