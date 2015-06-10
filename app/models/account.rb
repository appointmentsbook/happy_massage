class Account < ActiveRecord::Base
  has_many :massages
  has_many :penalties


end
