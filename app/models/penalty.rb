class Penalty < ActiveRecord::Base
  belongs_to :account

  validates_presence_of :punished_at, :punished_until, :reported_by
end
