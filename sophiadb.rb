require 'sophia-ruby'

#== SophiaDB
#
#    SophiaDB.new "sophia.db" # returns a new Sophia instance
#
class SophiaDB
  def initialize(path)
    # open
    @db = Sophia.new path

    # close the db on exit to prevent corruption
    at_exit do
      @db.close
      exit
    end
  end

  #== Get
  #
  #    db = SophiaDB.new "sophia.db" # returns a new Sophia instance
  #    db.get("foo") # returns key `foo`
  #
  def get(key)
    @db[key]
  end

  #== Fetch
  #
  #    db = SophiaDB.new "sophia.db" # returns a new Sophia instance
  #    db.fetch("foo") # returns key `foo`
  #
  def fetch(key)
    @db.fetch(key)
  end

  #== Set
  #
  #    db = SophiaDB.new "sophia.db" # returns a new Sophia instance
  #    db.set("foo", "bar") # sets key `foo` to `bar`
  #
  def set(key, value)
    @db[key] = value
  end

  #== Put
  #
  #    db = SophiaDB.new "sophia.db" # returns a new Sophia instance
  #    db.put("foo", "bar") # sets key `foo` to `bar`
  #
  def put(key, value)
    set(key, value)
  end

  #== Set
  #
  #    db = SophiaDB.new "sophia.db" # returns a new Sophia instance
  #    db.set("foo", "baz") # set key `foo` to `baz`
  #    db.update("foo", "bar") # updates key `foo` to `bar`
  #
  def update(*args)
    @db.update(*args)
  end

  #== Replace
  #
  #    db = SophiaDB.new "sophia.db" # returns a new Sophia instance
  #    db.set("foo", "bar")
  #    db.set("bar", "baz")
  #
  #    db.replace("foo" => "baz", "baz" => "bar") # updates key `foo` to `baz` and key `bar` to `bar`
  #
  def replace(*args)
    @db.replace(*args)
  end

  #== Delete
  #
  #    db = SophiaDB.new "sophia.db" # returns a new Sophia instance
  #    db.set("foo", "bar") # sets key `foo` to `bar`
  #    db.delete("foo") # delete key `foo`
  #
  def delete(key)
    @db.delete(key)
  end

  #== Del
  #
  #    db = SophiaDB.new "sophia.db" # returns a new Sophia instance
  #    db.set("foo", "bar") # sets key `foo` to `bar`
  #    db.del("foo") # delete key `foo`
  #
  def del(key)
    @db.delete(key)
  end

  #== Each
  #
  #    db = SophiaDB.new "sophia.db" # returns a new Sophia instance
  #    db.each do |key, value| # for each key, value
  #      puts key, value # output each k/v combo to the console
  #    end
  #
  def each
    @db.each(&Proc.new)
  end

  #== Each Key
  #
  #    db = SophiaDB.new "sophia.db" # returns a new Sophia instance
  #    db.each_key do |key| # for each key
  #      puts key # output each key to the console
  #    end
  #
  def each_key
    @db.each_key(&Proc.new)
  end

  #== Each Value
  #
  #    db = SophiaDB.new "sophia.db" # returns a new Sophia instance
  #    db.each_value do |value| # for each value
  #      puts value # output each value to the console
  #    end
  #
  def each_value
    @db.each_value(&Proc.new)
  end

  #== Keys
  #
  #    db = SophiaDB.new "sophia.db" # returns a new Sophia instance
  #    db.keys # an array of all the keys in the database
  #
  def keys
    @db.keys
  end

  #== Values
  #
  #    db = SophiaDB.new "sophia.db" # returns a new Sophia instance
  #    db.values # an array of all the values in the database
  #
  def values
    @db.values
  end

  #== Empty
  #
  #    db = SophiaDB.new "sophia.db" # returns a new Sophia instance
  #    db.empty! # empty the entire database
  #
  def empty!
    @db.clear
  end

  #== Filter
  #
  #    db = SophiaDB.new "sophia.db" # returns a new Sophia instance
  #    res = db.filter do |key, value| # for each value
  #      value == "string"
  #    end
  #
  def filter
    @db.find(&Proc.new)
  end

  #== Key?
  #
  #    db = SophiaDB.new "sophia.db" # returns a new Sophia instance
  #    db.key?("foo") # db contains key `foo`
  #
  def key?(key)
    @db[key] != nil
  end

  #== Value?
  #
  #    db = SophiaDB.new "sophia.db" # returns a new Sophia instance
  #    db.value?("foo") # db contains value `foo`
  #
  def value?(value)
    # @db.include?(value)
    @db.each_value do |v|
      return true if v == value
    end

    false
  end

  #== Key Values
  #
  #    db = SophiaDB.new "sophia.db" # returns a new Sophia instance
  #    db.key_values("foo", "bar", "baz") # returns the values of keys `foo`, `bar` and `baz`
  #
  def key_values(*keys)
    @db.values_at(*keys)
  end

  #== Length
  #
  #    db = SophiaDB.new "sophia.db" # returns a new Sophia instance
  #    db.length # number of keys in db
  #
  def length
    @db.length
  end

  #== Empty?
  #
  #    db = SophiaDB.new "sophia.db" # returns a new Sophia instance
  #    db.empty? # is the db empty?
  #
  def empty?
    @db.empty?
  end
end
