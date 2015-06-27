class Massage < ActiveRecord::Base
  belongs_to :user
  belongs_to :masseur

  validates_presence_of :timetable, :masseur_id, :user_id

  after_initialize :init_massage
  attr_accessor :status_machine

  def status_machine
    @status_machine ||= StateMachines::Massage::Status.new(self)
  end

  private

  def init_massage
    self.status = status_machine.current_state
  end
end
