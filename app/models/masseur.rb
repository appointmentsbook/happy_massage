class Masseur < ActiveRecord::Base
  include AASM

  has_many :massages, dependent: :destroy
  validates_presence_of :name, :email

  aasm column: :status do
    state(:pending, initial: true)
    state(:enabled)
    state(:disabled)

    event :enable, after: :update_masseur_status do
      transitions from: [:pending, :disabled], to: :enabled
    end

    event :disable, after: :update_masseur_status do
      transitions from: :enabled, to: :disabled
    end
  end

  scope :enabled, -> { where(status: 'enabled') }

  after_create :enable_user_if_status_is_pending

  private

  def update_masseur_status
    update_attributes!(status: aasm.current_state)
  end

  def enable_user_if_status_is_pending
    enable if status == 'pending'
  end
end
