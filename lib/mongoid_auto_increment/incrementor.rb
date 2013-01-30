# This is a modified version of the code found on this blog post:
#   http://ihswebdesign.com/blog/autoincrement-in-mongodb-with-ruby/
module MongoidAutoIncrement
  class Incrementor
    class Sequence
      def initialize(sequence, collection_name, seed)
        @sequence = sequence.to_s
        @collection = collection_name.to_s
        exists? || create(seed)
      end

       def inc
        opts = {
          "query"  => query,
          #"update" => {"$inc" => { "number" => 1 }},
          "update" => {"$inc" => { "val" => 1 }},
          "new"    => true # return the modified document
        }
        #collection.find_and_modify(opts)["number"]
        collection.find_and_modify(opts)["val"]
       end

      def current
        #collection.find_one(query)["number"]
        collection.find_one(query)["val"]
      end

      private

      def exists?
        collection.find(query).count > 0
      end

      def create(number)
        #collection.insert(query.merge({ "number" => number }))
        collection.insert(query.merge({ "val" => number }))
      end

      def collection
        Mongoid.database[@collection]
      end

      def query
        #{ "seq_name" => @sequence }
        { "name" => @sequence }
      end
    end

    def initialize(options=nil)
    end

    def inc(sequence, options)
      options ||= {}
      #collection = options[:collection] || "sequences"
      collection = options[:collection] || "sequence"
      seed = options[:seed].to_i
      Sequence.new(sequence, collection, seed).inc
    end
  end
end
