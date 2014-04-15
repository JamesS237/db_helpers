require 'sophia-ruby'

class SophiaDB
  def initialize(path)
    @db = Sophia.new path
  end

  # get
  def get(key)
    @db[key]
  end

  def fetch(key)
    @db.fetch(key)
  end

  # set
  def set(key, value)
    @db[key] = value
  end

  def put(key, value)
    set(key, value)
  end

  # update
  def update(*args)
    @db.update(*args)
  end

  def replace(*args)
    @db.replace(*args)
  end

  # delete
  def delete(key)
    @db.delete(key)
  end

  def del(key)
    @db.delete(key)
  end

  # iterate
  def each
    @db.each(&Proc.new)
  end

  def each_key
    @db.each_key(&Proc.new)
  end

  def each_value
    @db.each_value(&Proc.new)
  end

  # key
  def key(value)
    @db.key(value)
  end

  def keys
    @db.keys
  end

  # values
  def values
    @db.values
  end

  # empty
  def empty
    @db.clear
  end

  # filter
  def filter
    @db.find(&Proc.new)
  end

  # has
  def key?(key)
    @sophia.key?(key)
  end

  def value?(value)
    @sophia.value?(value)
  end

  # values
  def values(*keys)
    @db.values_at(*keys)
  end

  # size
  def length
    @db.length
  end

  def empty?
    @db.empty?
  end
end
