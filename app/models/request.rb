class Request < ActiveRecord::Base
  belongs_to :query
  attr_accessible :input, :output, :query_id
end
