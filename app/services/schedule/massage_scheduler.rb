module Schedule
  class MassageScheduler
    def initialize(args)
      @timetable = args.fetch(:timetable, nil)
      @user = args.fetch(:user)
      @massage = Massage.new(
        timetable: @timetable, user: @user, location: location
      )
    end

    def schedule_massage
      return @massage if timetable_is_invalid?

      masseur = available_masseurs.first
      return @massage if handle_timetable_unavailability(masseur)

      @massage.masseur = masseur
      @massage if @massage.save!
    rescue ActiveRecord::RecordNotUnique => e
      return @massage if handle_user_scheduling_once_again(e.message)
      retry
    end

    private

    def timetable_is_invalid?
      @massage.invalid? && @massage.errors.messages[:timetable].any?
    end

    def handle_timetable_unavailability(masseur)
      @massage.errors.add(:timetable, :unavailable_timetable) if masseur.nil?
    end

    def handle_user_scheduling_once_again(message)
      @massage.errors.add(
        :timetable, :taken
      ) if user_has_tried_to_get_more_than_one_massage?(message)
    end

    def user_has_tried_to_get_more_than_one_massage?(message)
      message.match(/index_massages_on_date_and_user_id/)
    end

    def available_masseurs
      Masseur
        .enabled
        .where("not exists (#{masseurs_given_massage_timetable_query})").to_a
    end

    def masseurs_given_massage_timetable_query
      Massage
        .select('NULL').where(timetable: @massage.timetable)
        .where('massages.masseur_id = masseurs.id').to_sql
    end

    def location
      @location ||= ScheduleSettings.location
    end
  end
end
