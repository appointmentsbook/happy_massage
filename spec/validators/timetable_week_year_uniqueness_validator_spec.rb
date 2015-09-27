class TimetableWeekYearUniquenessSample
  include ActiveModel::Validations

  validates :timetable, timetable_week_year_uniqueness: true

  attr_accessor :timetable, :user

  def initialize(timetable, user)
    @timetable = timetable
    @user = user
  end
end

describe TimetableWeekYearUniquenessValidator do
  describe '#validate' do
    let(:timetable) { double('timetable') }
    let(:user) { double('user') }

    subject(:timetable_sample) do
      TimetableWeekYearUniquenessSample.new(timetable, user)
    end

    context 'when user has not scheduled in this week during this year' do
      before do
        allow_any_instance_of(described_class)
          .to receive(:user_has_not_scheduled_this_week_in_this_year?)
          .and_return(true)
      end

      it { is_expected.to be_valid }
    end

    context 'when user has not scheduled in this week during this year' do
      before do
        allow_any_instance_of(described_class)
          .to receive(:user_has_not_scheduled_this_week_in_this_year?)
          .and_return(false)
      end

      it { is_expected.to be_invalid }
    end
  end
end
