require 'gnista'

module Sparkey
  #== SparkeyConnection
  #
  #    SparkeyConnection.new "mylog.log", "mylog.hash" # returns a gnista reader, writer and hash reader.
  #
  class SparkeyConnection
    def initialize(path, hash = nil)
      # writer
      @writer = Gnista::Logwriter.new path unless File.exist?(path)
      @writer = Gnista::Logwriter.new path, :append if File.exist?(path)

      # reader
      @reader = Gnista::Logreader.new path

      # hash
      @hash = Gnista::Hash.write hash, path if hash
    end
    attr_reader @writer
    attr_reader @reader
    attr_reader @hash
  end

  # == Write
  #
  #    writer = Sparkey::Write.new "mylog.log"
  class Write
    def initialize(path, hash = nil)
      # open
      @connections = SparkeyConnection.new(path)
      @writer = @connections.writer

      @flushing = true
    end

    # == Put
    #
    #    writer = Sparkey::Write.new "mylog.log"
    #    writer.put("foo", "bar") #key `foo` = `bar`
    #
    def put(key, value)
      @writer.put(key, value)
      @writer.flush if @flushing
    end

    # == Set
    #
    #    writer = Sparkey::Write.new "mylog.log" # create writer
    #    writer.set("foo", "bar") # key `foo` = `bar`
    #
    def set(key, value, flush)
      @writer.put(key, value)
      @writer.flush if @flushing
    end

    # == Delete
    #
    #    writer = Sparkey::Write.new "mylog.log" # create writer
    #    writer.set("foo", "bar") # key `foo` = `bar`
    #    writer.del("foo") # delete key `foo`
    #
    def del(key)
      @writer.del(key)
      @writer.flush if @flushing
    end

    # == Batch
    #
    #    writer = Sparkey::Write.new "mylog.log" # create writer
    #    writer.batch do
    #     writer.put("foo", "bar")
    #     writer.put("bar", "baz")
    #
    #     writer.del("bar")
    #    end
    #
    def batch
      @flushing = false
      yield if block_given?
      @writer.flush
      @flushing = true
    end

    # == Flush
    #
    #    writer = Sparkey::Write.new "mylog.log" # create writer
    #    writer.flush # flush to database
    #
    def flush
      @writer.flush
    end

    # == Close
    #
    #    writer = Sparkey::Write.new "mylog.log" # create writer
    #    writer.close # close connection
    #
    def close
      @writer.close
    end
  end

  # == Write
  #
  #    reader = Sparkey::Read.new "mylog.log"
  class Read
    def initialize(path)
      # open
      @connections = SparkeyConnection.new(path)
      @reader = @connections.reader
    end

    # == Each
    #
    #    reader = Sparkey::Read.new "mylog.log" # create reader
    #    reader.each do |chunk|
    #      key = chunk[0] # first chunk element is the key
    #      value = chunk[1] # second chunk element is the value
    #      op = chunk[2] # third chunk element is the operation in the log
    #
    #      puts key, value, op
    #    end
    #
    def each
      @reader.each do |key, value, type|
        yield [key, value, type] if block_given?
      end
    end

    # == Close
    #
    #    reader = Sparkey::Read.new "mylog.log" # create reader
    #    reader.close # close connection
    #
    def close
      @reader.close
    end
  end

  # == Hash
  #
  #    hash = Sparkey::Hash.new "mylog.log", "mylog.hash"
  class Hash
    def initialize(path, hash)
      @connections = SparkeyConnection.new(path, hash)
      @hash = @connections.hash
    end

    # == Get
    #
    #    hash = Sparkey::Hash.new "mylog.log", "mylog.hash" # create hash reader
    #    hash.get("foo") # returns value at key `foo` in the hash
    #
    def get(key)
      @hash.get(key)
    end

    # == Each
    #
    #    hash = Sparkey::Hash.new "mylog.log", "mylog.hash" # create hash reader
    #    hash.each do |chunk|
    #      key = chunk[0] # first chunk element is the key
    #      value = chunk[1] # second chunk element is the value
    #      op = chunk[2] # third chunk element is the operation in the hash
    #
    #      puts key, value, op
    #    end
    #
    def each(hash)
      @hash.each do |key, value, type|
        yield [key, value, type] if block_given?
      end
    end

    # == Includes?
    #
    #    hash = Sparkey::Hash.new "mylog.log", "mylog.hash" # create hash reader
    #    hash.include?("foo") # is the key `foo` in the hash
    #
    def include?(key)
      @hash.include? key
    end

    # == Empty
    #
    #    hash = Sparkey::Hash.new "mylog.log", "mylog.hash" # create hash reader
    #    hash.empty? # is the hash empty
    #
    def empty?
      @hash.empty?
    end

    # == Collisions
    #
    #    hash = Sparkey::Hash.new "mylog.log", "mylog.hash" # create hash reader
    #    hash.collisions # collisions in the hash
    #
    def collisions
      @hash.collisions
    end

    # == Union
    #
    #    hash = Sparkey::Hash.new "mylog.log", "mylog.hash" # create hash reader
    #    hash.union # collisions in the hash
    #
    def union
      @hash.collisions
    end

    # == Keys
    #
    #    hash = Sparkey::Hash.new "mylog.log", "mylog.hash" # create hash reader
    #    hash.keys # an array of all the keys in the hash
    #
    def keys
      @hash.keys
    end


    # == Values
    #
    #    hash = Sparkey::Hash.new "mylog.log", "mylog.hash" # create hash reader
    #    hash.values # an array of all the values in the hash
    #
    def values
      @hash.values
    end


    # == Length
    #
    #    hash = Sparkey::Hash.new "mylog.log", "mylog.hash" # create hash reader
    #    hash.length # size of the hash
    #
    def length
      @hash.length
    end

    # == MaxKeyLen
    #
    #    hash = Sparkey::Hash.new "mylog.log", "mylog.hash" # create hash reader
    #    hash.maxkeylen # largest key in the hash
    #
    def maxkeylength
      @hash.maxkeylen
    end

    # == MaxValueLen
    #
    #    hash = Sparkey::Hash.new "mylog.log", "mylog.hash" # create hash reader
    #    hash.maxvaluelen # largest value in the hash
    #
    def maxvaluelength
      @hash.maxvaluelen
    end

    # == Close
    #
    #    hash = Sparkey::Hash.new "mylog.log", "mylog.hash" # create hash reader
    #    hash.close # close connection
    #
    def close
      @hash.close
    end
  end
end
