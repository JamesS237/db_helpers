require 'leveldb'

#== LevelDB
#
#    Level.new "level.db" # returns a new Level instance
#
class Level
  def initialize(path)
    @db = LevelDB::DB.new path
    at_exit do
      @db.close
      exit
    end
  end

  #== Put
  #
  #    db = Level.new "level.db" # returns a new Level instance
  #    db.put("foo", "bar") # sets key `foo` to `bar`
  #
  def put(key, value)
    @db.put(key, value)
  end

  #== Set
  #
  #    db = Level.new "level.db" # returns a new Level instance
  #    db.set("foo", "bar") # sets key `foo` to `bar`
  #
  def set(key, value)
    @db.put(key, value)
  end

  #== Get
  #
  #    db = Level.new "level.db" # returns a new Level instance
  #    db.get("foo") # returns key `foo`
  #
  def get(key)
    @db.get(key)
  end

  #== Delete
  #
  #    db = Level.new "level.db" # returns a new Level instance
  #    db.set("foo", "bar") # sets key `foo` to `bar`
  #    db.delete("foo") # delete key `foo`
  #
  def delete(key)
    @db.delete(key)
  end

  #== Del
  #
  #    db = Level.new "level.db" # returns a new Level instance
  #    db.set("foo", "bar") # sets key `foo` to `bar`
  #    db.del("foo") # delete key `foo`
  #
  def del(key)
    @db.delete(key)
  end

  #== Each
  #
  #    db = Level.new "level.db" # returns a new Level instance
  #    db.each(true) do |chunk| # for each chunk, in reverse order
  #      puts chunk[0] # key
  #      puts chunk[1] # value
  #    end
  #
  def each(reversed = false)
    if reversed
      @db.reverse_each do |k, v|
        yield [k, v] if block_given?
      end
    else
      @db.each do |k, v|
        yield [k, v] if block_given?
      end
    end
  end

  #== Range
  #
  #    db = Level.new "level.db" # returns a new Level instance
  #    db.range("a", "z") do |chunk| # for each chunk in range `a` > `z`
  #      puts chunk[0] # key
  #      puts chunk[1] # value
  #    end
  #
  def range(f, t)
    @db.range(f, t) do |k, v|
      yield [k, v] if block_given?
    end
  end

  #== Keys
  #
  #    db = Level.new "level.db" # returns a new Level instance
  #    db.keys # an array of all the keys in the database
  #
  def keys
    @db.keys
  end

  #== Map
  #
  #    db = Level.new "level.db" # returns a new Level instance
  #    db.map do |chunk| # for each chunk, in reverse order
  #      puts chunk[0] # key
  #      puts chunk[1] # value
  #    end
  #
  def map
    @db.map(Proc.new { |key, value|
      yield [key, value]
    }) if block_given?
  end

  #== Reduce
  #
  #    db = Level.new "level.db" # returns a new Level instance
  #    db.reduce do |chunk| # for each chunk, in reverse order
  #      puts chunk[0] # key
  #      puts chunk[1] # value
  #    end
  #
  def reduce(arr = [])
    @db.reduce(arr, Proc.new { |key, value|
      yield [key, value]
    }) if block_given?
  end

  #== Includes?
  #
  #    db = Level.new "level.db" # returns a new Level instance
  #    db.includes?("foo") # db contains key `foo`
  #
  def includes?(key)
    @db.includes? key
  end

  #== Contains?
  #
  #    db = Level.new "level.db" # returns a new Level instance
  #    db.contains?("foo") # db contains key `foo`
  #
  def contains?(key)
    @db.contains? key
  end

  #== Batch
  #
  #    db = Level.new "level.db" # returns a new Level instance
  #    db.batch do |d| # create a batch operation with a batch runner
  #      d.put("foo", "bar")
  #      d.put("sweet", "very yes")
  #    end # run em all
  #
  def batch
    bop = @db.batch
    yield(bop)
    bop.write!
  end

  #== Snap
  #
  #    db = Level.new "level.db" # returns a new Level instance
  #    db.snap # return a new Snapshot for the DB in it's current state
  #
  def snap
    Snapshot.new(@db.snapshot)
  end

  #== Prop
  #
  #    db = Level.new "level.db" # returns a new Level instance
  #    db.prop("foo") # get db property `foo`
  #
  def prop(p)
    @db.read_property(p)
  end

  #== Stats
  #
  #    db = Level.new "level.db" # returns a new Level instance
  #    db.stats # output db stats
  #
  def stats
    @db.stats
  end
end

#== Snapshot
#
#    s = Snapshot.new(@db.snapshot) # returns a new Snapshot instance
#
class Snapshot
  def initialize(snap)
    @snap = snap
  end

  #== Rewind
  #
  #    s = Snapshot.new(@db.snapshot) # returns a new Snapshot instance
  #    s.rewind! # rewind back to when the snapshot was taken
  #
  def rewind!
    @snap.set!
  end

  #== FastForward
  #
  #    s = Snapshot.new(@db.snapshot) # returns a new Snapshot instance
  #    s.fastforward! # fastforward to the state in time when the rewind occured
  #
  def fastforward!
    @snap.reset!
  end
end
