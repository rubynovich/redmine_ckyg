class WorkplaceTime < ActiveRecord::Base
  unloadable

  belongs_to :user

  validates_presence_of :user_id, :workday, :start_time, :duration, :delay
  validates_uniqueness_of :workday, :scope => :user_id
end
