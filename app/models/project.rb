class Project < ActiveRecord::Base
  has_one :general_repair_permit
  accepts_nested_attributes_for :general_repair_permit
end
