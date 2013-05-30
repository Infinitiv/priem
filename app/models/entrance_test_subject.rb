class EntranceTestSubject < ActiveRecord::Base
  belongs_to :entrance_test_item
  attr_accessible :subject_id
end
