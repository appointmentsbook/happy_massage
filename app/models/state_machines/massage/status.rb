module StateMachines
  module Massage
    class Status
      STATES_AFTER_SCHEDULE = %w(scheduled attended cancelled missed)
      attr_accessor :current_state

      def initialize(massage)
        @massage = massage
      end

      def current_state
        @massage.status.nil? ? initial_state : @massage.status
      end

      STATES_AFTER_SCHEDULE.each do |state|
        define_method("massage_has_been_#{state}!") do
          @massage.update_attributes!(status: state)
        end
      end

      private

      def initial_state
        @massage.status = 'pending'
      end
    end
  end
end
