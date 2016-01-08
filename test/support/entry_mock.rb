class ActiveRecord; end
class ActiveRecord::Base < ActiveRecord; end
class EntryMock < ActiveRecord::Base
  attr_accessor :name
  attr_accessor :body

  def initialize(name, body)
    @name = name
    @body = body
  end

  def self.column_names
    %w(name body)
  end
end
