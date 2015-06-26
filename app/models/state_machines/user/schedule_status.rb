module StateMachines
  module User
    class ScheduleStatus
      include AASM

      aasm do
        state(:disabled, initial: true)
        state(:enabled)
        state(:enabled_under_warning)
        state(:forbidden_for_1_week)
        state(:forbidden_for_1_month)

        event(:enable_scheduling, after: :update_schedule_status) do
          transitions(from: :disabled, to: :enabled)
        end

        event(:penalize_absence, after: :update_schedule_status) do
          transitions(from: :enabled, to: :enabled_under_warning)
          transitions(from: :enabled_under_warning, to: :forbidden_for_1_week)
          transitions(from: :forbidden_for_1_week, to: :forbidden_for_1_month)
        end
      end

      attr_accessor :user

      def initialize(user)
        @user = user
        aasm.current_state = user.schedule_status.to_sym if user.schedule_status
      end

      private

      def update_schedule_status
        user.update_attributes!(schedule_status: aasm.to_state)
      end
    end
  end
end