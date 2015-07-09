module Schedule
  class MassageScheduler
    def initialize(args)
      @timetable = args.fetch(:timetable)
    end

    def schedule
      masseur = find_available_masseur
    end

    private

    def find_available_masseur
      Masseur.where(
        "not exists (#{
          Massage.select('NULL').where(timetable: @timetable)
          .where("massages.masseur_id = masseurs.id").to_sql
        })"
      )
    end
  end
end
