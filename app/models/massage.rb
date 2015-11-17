class Massage < ActiveRecord::Base
  include StateMachines::Massage::Status

  belongs_to :user
  belongs_to :masseur

  validates_presence_of :masseur_id, :user_id

  validates(
    :timetable,
    timetable: true,
    uniqueness: { scope: [:user_id, :date] },
    timetable_week_year_uniqueness: true,
    on: :create
  )

  scope :scheduled_massages, -> { where(status: 'scheduled') }
  scope :past_massages, -> { where.not(status: 'scheduled') }

  before_validation :retrieve_date_from_timetable

  def cancel!
    destroy! if can_be_cancelled?
  end

  def can_be_cancelled?
    scheduled? && last_time_to_cancel_has_not_been_reached?
  end

  private

  def retrieve_date_from_timetable
    self.date = timetable
  end

  def update_massage_status!
    update_attributes!(status: aasm.to_state)
  end

  def last_time_to_cancel_has_not_been_reached?
    Time.zone.now <= last_time_to_cancel_the_massage
  end

  def last_time_to_cancel_the_massage
    timetable - 30.minutes
  end
end
