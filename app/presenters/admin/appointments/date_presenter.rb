module Admin
  module Appointments
    class DatePresenter
      def initialize(date)
        @date = date
      end

      def formatted_date
        has_valid_date? ? I18n.l(date_parser.parsed_date) : ''
      end

      def has_valid_date?
        date_parser.valid_date?
      end

      private

      def date_parser
        @date_parser ||= Admin::Appointments::DateParser.new(@date)
      end
    end
  end
end
