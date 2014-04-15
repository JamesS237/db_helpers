require 'gnista'

module Sparkey
  # This class opens a connection to Sparkey
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

  # This class opens a write connection to Sparkey

  class Write
    def initialize(path, hash = nil)
      # open
      @connections = SparkeyConnection.new(path)
      @writer = @connections.writer

      @flushing = true
    end

    # set
    def put(key, value)
      @writer.put(key, value)
      @writer.flush if @flushing
    end

    def set(key, value, flush)
      @writer.put(key, value)
      @writer.flush if @flushing
    end

    # delete
    def del(key)
      @writer.del(key)
      @writer.flush if @flushing
    end

    # batch
    def batch
      @flushing = false
      yield if block_given?
      @writer.flush
      @flushing = true
    end

    # flush
    def flush
      @writer.flush
    end

    # close
    def close
      @writer.close
    end
  end

  # This class creates a read connection to Sparkey

  class Read
    def initialize(path)
      # open
      @connections = SparkeyConnection.new(path)
      @reader = @connections.reader
    end

    # iterate
    def each
      @reader.each do |key, value, type|
        yield [key, value, type] if block_given?
      end
    end

    # close
    def close
      @reader.close
    end
  end

  # This class a hash connection to Sparkey

  class Hash
    def initialize(path, hash)
      @connections = SparkeyConnection.new(path, hash)
      @hash = @connections.hash
    end

    # get
    def get(key)
      @hash.get(key)
    end

    # iterator
    def each(hash)
      @hash.each do |key, value, type|
        yield [key, value, type]
      end
    end

    # contents
    def include?(key)
      @hash.include? key
    end

    def empty?
      @hash.empty?
    end

    # union
    def collisions
      @hash.collisions
    end

    def union
      @hash.collisions
    end

    # key
    def keys
      @hash.keys
    end

    # value
    def values
      @hash.values
    end

    # lengths
    def length
      @hash.length
    end

    def maxkeylen
      @hash.maxkeylen
    end

    def maxvaluelength
      @hash.maxvaluelen
    end

    # close
    def close
      @hash.close
    end
  end
end
