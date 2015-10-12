class User < ActiveRecord::Base
  has_many :massages, dependent: :destroy

  validates_presence_of :login, :name, :email

  def self.retrieve_from(user_session)
    find_or_create_by!(
      login: user_session.login,
      name: user_session.name,
      email: user_session.email
    )
  end
end
