require 'leveldb'

class Level
  def initialize(path)
    @db = LevelDB::DB.new path
  end

  def keys
    @db.keys
  end

  def put(key, value)
    @db.put(key, value)
  end

  def set(key, value)
    @db.put(key, value)
  end

  def get(key)
    @db.get(key)
  end

  def delete(key)
    @db.delete(key)
  end

  def del(key)
    @db.delete(key)
  end

  def includes?(key)
    @db.includes? key
  end

  def contains?(key)
    @db.contains? key
  end

  def each(reversed=false)
    if reversed
      @db.reverse_each do |k, v|
        yield [k, v] if block_given?
      end
    else
      @db.each do |k, v|
        yield [k, v] if block_given?
      end
    end
  endi

  def batch
    bop = @db.batch
    ret = yield(bop)
    bop.write!
  end

  def range(f, t)
    @db.range(f, t) do |k, v|
      yield [k, v] if block_given?
    end
  end

  def map
    @db.map(&Proc.new) if block_given?
  end

  def reduce(arr=[])
    @db.reduce(arr, &Proc.new) if block_given?
  end

  def snap
    s = Snapshot.new(@db.snapshot)
    s
  end

  def prop(p)
    @db.read_property(p)
  end

  def stats
    @db.stats
  end
end

class Snapshot
  def initialize(snap)
    @snap = snap
  end

  def rw
    @snap.set!
  end

  def ff
    @snap.reset!
  end
end


