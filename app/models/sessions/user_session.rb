module Sessions
  class UserSession < BaseSession
    EMPLOYEE_TYPE = 'Employee'

    def initialize(session)
      @session = session
    end

    def employee?
      extra_attributes && extra_attributes[:type] == EMPLOYEE_TYPE
    end
  end
end
