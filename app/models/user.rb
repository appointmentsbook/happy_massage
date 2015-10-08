class User < ActiveRecord::Base
  has_many :massages, dependent: :destroy

  validates_presence_of :name, :email
end
