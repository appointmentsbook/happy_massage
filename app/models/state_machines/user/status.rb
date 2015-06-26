module StateMachines
  module User
    class Status
      include AASM

      aasm do
        state(:pending, initial: true)
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
        aasm.current_state = user.status.to_sym if user.status
      end

      def update_user_status
        update_status!(aasm.to_state)
      end

      private

      def update_status!(status)
        user.update_attributes!(status: status)
      end
    end
  end
end
