module Schedule
  class TimetablesPresenter
    def available_timetables
      available_timetables = []

      schedule_table.each do |timetable|
        massages_left = enabled_masseurs - scheduled_massages[timetable].to_i
        next if massages_left.zero?

        available_timetables << [timetable, massages_left]
      end
      available_timetables
    end

    private

    def scheduled_massages
      @schedule_massages ||= begin
        query = Massage.where('date(timetable) = ?', massage_date)
                      .group(:timetable).count(:id)
        Hash[query.map { |key, value| [key.in_time_zone, value] }]
      end
    end

    def massage_date
      @massage_date ||= begin
        Schedule::MassageDateFinder.new(Time.zone.today).massage_date
      end
    end

    def schedule_table
      Rails.cache.fetch(cache_key, expires_in: 10.minutes) do
        Schedule::TableGenerator.new(massage_date).schedule_table
      end
    end

    def cache_key
      "#{massage_date}/schedule_table"
    end

    def enabled_masseurs
      @enabled_masseurs ||= Masseur.enabled.count
    end
  end
end
