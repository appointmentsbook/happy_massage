module StateMachines
  class User
    include AASM

    aasm do
      state(:pending, initial: true)
      state(:enabled)
      state(:disabled)

      event :agree_with_rules do
        transitions from: :pending, to: :enabled
      end

      event :disable do
        transitions from: :enabled, to: :disabled
      end

      event :enable do
        transitions from: :disabled, to: :enabled
      end
    end

    attr_accessor :user

    def initialize(user)
      @user = user
      aasm.current_state = status
    end

    def status
      user.status
    end

    def update_user_status
      user.status = aasm.to_state
    end
  end
end
