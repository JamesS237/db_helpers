require 'sophia-ruby'

class SophiaDB
  def initialize(path)
    @db = Sophia.new path
    at_exit do
      @db.close
      exit
    end
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
    !!@db[key]
  end

  def value?(value)
    #@db.include?(value)
    @db.each_value do |v|
      return true if v == value
    end

    false
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
