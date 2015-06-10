class Masseur < ActiveRecord::Base
  has_many :massages

  validates_presence_of :name, :email
end
