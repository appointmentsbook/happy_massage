class Massage < ActiveRecord::Base
  belongs_to :user
  belongs_to :masseur

  validates_presence_of :masseur_id, :user_id
  validates :timetable, timetable: true

  attr_accessor :status_machine

  after_initialize :init_massage
  after_create :change_status_to_scheduled

  scope :next_massages, -> { where(status: 'scheduled') }
  scope :past_massages, -> { where.not(status: 'scheduled') }

  def status_machine
    @status_machine ||= StateMachines::Massage::Status.new(self)
  end

  def cancel!
    destroy! if can_be_cancelled?
  end

  def can_be_cancelled?
    status_machine.scheduled? && last_time_to_cancel_has_not_been_reached?
  end

  private

  def init_massage
    self.status = status_machine.current_state
  end

  def change_status_to_scheduled
    status_machine.schedule! if status == 'pending'
  end

  def last_time_to_cancel_has_not_been_reached?
    Time.zone.now <= last_time_to_cancel_the_massage
  end

  def last_time_to_cancel_the_massage
    timetable - 30.minutes
  end
end
