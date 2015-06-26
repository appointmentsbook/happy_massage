module StateMachines
  module User
    class Status
      attr_accessor :current_state

      def initialize(user)
        @user = user
      end

      def current_state
        @user.status.nil? ? initial_state : @user.status
      end

      def deactivate!
        @user.update_attributes!(status: 'disabled')
      end

      def activate!
        @user.update_attributes!(status: 'enabled')
      end

      private

      def initial_state
        @user.status = 'pending'
      end
    end
  end
end
