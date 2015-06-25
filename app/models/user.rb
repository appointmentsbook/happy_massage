class User < ActiveRecord::Base
  has_many :massages, dependent: :destroy
  has_many :penalties, dependent: :destroy

  validates_presence_of :name, :email

  after_initialize :init_account

  attr_accessor :status_machine

  private

  def init_account
    return if persisted?

    self.status = status_machine.aasm.current_state.to_s
  end

  def status_machine
    @status_machine ||= StateMachines::User::Status.new(self)
  end
end
