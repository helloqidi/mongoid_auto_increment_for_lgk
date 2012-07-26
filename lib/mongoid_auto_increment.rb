require "mongoid_auto_increment/incrementor"

module MongoidAutoIncrement
  extend ActiveSupport::Concern

  module ClassMethods
    def auto_increment(name, options={})
      field name, :type => Integer
      #seq_name = "#{self.name.downcase}_#{name}"
      seq_name = "#{self.name.downcase}"
      @@incrementor = MongoidAutoIncrement::Incrementor.new unless defined? @@incrementor

      before_create do
        #if #{name} is not Integer instance,then to replace it with Integer.  
        self.send("#{name}=", @@incrementor.inc(seq_name, options)) unless self.send("#{name}").is_a?(Integer)
      end
    end
  end
end

module Mongoid
  module Document
    include MongoidAutoIncrement
  end
end
