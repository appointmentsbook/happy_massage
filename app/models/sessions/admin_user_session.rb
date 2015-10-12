module Sessions
  class AdminUserSession < BaseSession
    ADMIN_N2 = 'HAPPY_MASSAGE_ADMIN-N2'
    ADMIN_N3 = 'HAPPY_MASSAGE_ADMIN-N3'

    def initialize(session)
      @session = session
    end

    def admin?
      admin_n2? || admin_n3?
    end

    def admin_n3?
      authorities_checker(ADMIN_N3)
    end

    private

    def admin_n2?
      authorities_checker(ADMIN_N2)
    end

    def authorities_checker(role)
      extra_attributes && extra_attributes[:authorities].include?(role)
    end
  end
end
