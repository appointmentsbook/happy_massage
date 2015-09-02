module StateMachines
  module Massage
    module Status
      def self.included(base)
        base.send(:include, AASM)

        base.send(:aasm, column: 'status') do
          state(:pending, initial: true)
          state(:scheduled)
          state(:attended)
          state(:missed)

          event(:schedule, after: :update_massage_status!) do
            transitions(from: :pending, to: :scheduled)
          end

          event(:attend, after: :update_massage_status!) do
            transitions(from: [:scheduled, :attended, :missed], to: :attended)
          end

          event(:miss, after: :update_massage_status!) do
            transitions(from: [:scheduled, :attended, :missed], to: :missed)
          end
        end
      end
    end
  end
end
