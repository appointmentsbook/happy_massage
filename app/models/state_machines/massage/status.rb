module StateMachines
  module Massage
    class Status
      include AASM

      aasm do
        state(:pending, initial: true)
        state(:scheduled)
        state(:attended)
        state(:cancelled)
        state(:missed)

        event(:schedule!, after: :update_massage_status) do
          transitions(from: :pending, to: :scheduled)
        end

        event(:mark_presence!, after: :update_massage_status) do
          transitions(from: :scheduled, to: :attended)
        end

        event(:mark_absence!, after: :update_massage_status) do
          transitions(from: :scheduled, to: :missed)
        end
      end

      def initialize(massage)
        @massage = massage
        aasm.current_state = massage.status.to_sym if massage.status
      end

      def current_state
        @massage.status.nil? ? initial_state : @massage.status
      end

      def status
        @massage.status
      end

      private

      def initial_state
        @massage.status = 'pending'
      end

      def update_massage_status
        @massage.update_attributes!(status: aasm.to_state)
      end
    end
  end
end
