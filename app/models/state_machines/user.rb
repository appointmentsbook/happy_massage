module StateMachines
  class User
    include AASM

    aasm do
      state(:pending, :initial => true)
      state(:enabled)
      state(:disabled)

      event(:activate, after: :update_user_status) do
        transitions(from: [:pending, :disabled], to: :enabled)
      end

      event(:deactivate, after: :update_user_status) do
        transitions(from: [:pending, :enabled], to: :disabled)
      end
    end

    attr_accessor :user

    def initialize(user)
      @user = user
      sync_status
    end

    def status
      user.status
    end

    def update_user_status
      update_status!(aasm.to_state)
    end

    private

    def sync_status
      status ? aasm.current_state = status : update_status!(aasm.current_state)
    end

    def update_status!(status)
      user.update_attributes!(status: status)
    end
  end
end
