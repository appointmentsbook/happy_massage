class User < ActiveRecord::Base
  has_many :massages, dependent: :destroy

  validates_presence_of :name, :email

  after_initialize :init_account

  attr_accessor :status_machine

  def status_machine
    @status_machine ||= StateMachines::User::Status.new(self)
  end

  private

  def init_account
    return if persisted?

    self.status = status_machine.current_state
  end
end
