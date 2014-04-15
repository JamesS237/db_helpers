require 'gnista'

module Sparkey
  class SparkeyConnection
    def initialize(path, hash=nil)
      if !File.exist?(path)
        @writer = Gnista::Logwriter.new path
        @writer.put("created", "true")

        @reader = Gnista::Logreader.new path
      else
        @writer = Gnista::Logwriter.new path, :append
        @reader = Gnista::Logreader.new path
      end

      if hash
       @hash = Gnista::Hash.write hash, path
      end
    end

    def getwriter
      @writer
    end

    def getreader
      @reader
    end

    def gethash
      @hash
    end
  end

  class Write
    def initialize(path, hash=nil)
      @connections = SparkeyConnection.new(path)
      @writer = @connections.getwriter

      @flushing = true
    end

    def put(key, value)
      @writer.put(key, value)
      @writer.flush if @flushing
    end

    def set(key, value, flush)
      @writer.put(key, value)
      @writer.flush if @flushing
    end

    def del(key)
      @writer.del(key)
      @writer.flush if @flushing
    end

    def batch
      @flushing = false
      yield if block_given?
      @writer.flush
      @flushing = true
    end

    def flush
      @writer.flush
    end

    def close
      @writer.close
    end
  end

  class Read
    def initialize(path)
      @connections = SparkeyConnection.new(path)
      @reader = @connections.getreader
    end

    def each
      @reader.each do |key,value,type|
        yield [key, value, type] if block_given?
      end
    end
  end

  class Hash
    def initialize(path, hash)
      @connections = SparkeyConnection.new(path, hash)
      @hash = @connections.gethash
    end

    def get(key)
      @hash.get(key)
    end

    def each(hash)
      @hash.each do |key,value,type|
        yield [key, value, type]
      end
    end

    def maxkeylen
      @hash.maxkeylen
    end

    def maxvaluelength
      @hash.maxvaluelen
    end

    def include?(key)
      @hash.include? key
    end

    def empty?
      @hash.empty?
    end

    def collisions
      @hash.collisions
    end

    def length
      @hash.length
    end

    def keys
      @hash.keys
    end

    def values
      @hash.values
    end
  end
end