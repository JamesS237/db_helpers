require 'hyperloglog-redis'

# This class creates a redis based HyperLogLog.

class HyperLog
  def initialize(redis)
    @counter = HyperLogLog::Counter.new(redis)
  end

  def create(name, array)
    array.each do |i|
      @counter.add(name, i)
    end
  end

  def add(name, items)
    if items.is_a?(Array)
      items.each do |i|
        @counter.add(name, i)
      end
    else
      @counter.add(name, items)
    end
  end

  def count(name)
    @counter.count(name)
  end

  def union(sets)
    @counter.union(sets)
  end

  def union_store(sets, out)
    @counter.union_store(name, out)
  end

  def intersect(sets)
    @counter.intersection(sets)
  end
end