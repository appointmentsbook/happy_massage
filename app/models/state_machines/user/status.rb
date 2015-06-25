module StateMachines
  module User
    class Status
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

      def update_user_status
        update_status!(aasm.to_state)
      end

      private

      def sync_status
        if user.status.nil?
          user.status = aasm.current_state.to_s
        else
          aasm.current_state = user.status.to_sym
        end
      end

      def update_status!(status)
        user.update_attributes!(status: status)
      end
    end
  end
end
