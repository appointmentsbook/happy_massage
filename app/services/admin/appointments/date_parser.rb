module Admin
  module Appointments
    class DateParser
      attr_reader :date

      def initialize(date)
        @date = date
      end

      def valid_date?
        parsed_date.is_a?(Date)
      end

      def parsed_date
        @date_value ||= begin
          date.nil? ? date : Date.parse(date)
        rescue ArgumentError
          nil
        end
      end
    end
  end
end
