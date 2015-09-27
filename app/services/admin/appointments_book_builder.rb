module Admin
  class AppointmentsBookBuilder
    attr_reader :date

    def initialize(date)
      @date = date
    end

    def appointments
      @appointments ||= appointments_list
    end

    private

    def appointments_list
      list = []

      timetables.each do |timetable|
        available_masseurs.each do |masseur|
          list << [timetable, masseur.name, massage(timetable, masseur)]
        end
      end

      list
    end

    def scheduled_massages
      @scheduled_massages ||= begin
        scheduled_massages_query.group_by do |massage|
          [massage.timetable, massage.masseur_id]
        end
      end
    end

    def scheduled_massages_query
      Massage
        .where('date = ?', date).joins(:user, :masseur)
        .select(
          'massages.id AS id',
          'massages.timetable as timetable',
          'massages.masseur_id as masseur_id',
          'massages.status as status',
          'users.name AS user_name',
          'masseurs.name AS masseur_name'
        )
    end

    def timetables
      @timetables ||= Schedule::TableGenerator.new(date).schedule_table
    end

    def available_masseurs
      @available_masseurs ||= Masseur.enabled.order(:name)
    end

    def massage(timetable, masseur)
      scheduled_massages.try(:[], [timetable, masseur.id]).try(:first)
    end
  end
end
