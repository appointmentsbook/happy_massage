class Massage < ActiveRecord::Base
  belongs_to :user
  belongs_to :masseur

  validates_presence_of :timetable, :masseur_id, :user_id
end
