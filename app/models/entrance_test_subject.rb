class EntranceTestSubject < ActiveRecord::Base
  belongs_to :entrance_test_item
  attr_accessible :entrance_test_item_id, :subject_id
end
