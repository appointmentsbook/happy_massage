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

          event(:schedule!, after: :update_massage_status!) do
            transitions(from: :pending, to: :scheduled)
          end

          event(:mark_presence!, after: :update_massage_status!) do
            transitions(from: :scheduled, to: :attended)
          end

          event(:mark_absence!, after: :update_massage_status!) do
            transitions(from: :scheduled, to: :missed)
          end
        end
      end
    end
  end
end
