describe Massage do
  describe 'validations' do
    context 'presence validations' do
      it { is_expected.to validate_presence_of(:masseur_id) }
      it { is_expected.to validate_presence_of(:user_id) }
    end

    context 'timetable validations' do
      let(:masseur) { create(:masseur) }
      let(:user) { create(:user) }
      subject(:massage) do
        described_class.new(
          timetable: timetable,
          user: user,
          masseur: masseur
        )
      end

      context 'when user has not schedule yet during a week' do
        context 'when a day of the week does not have scheduling' do
          let(:timetable) { '2015-08-03' }

          before { Timecop.travel('2015-08-03 14:29') }
          after { Timecop.return }

          it { is_expected.to be_invalid }

          context 'after validation' do
            before { massage.valid? }

            it 'adds an error message to timetable field' do
              expect(massage.errors.messages[:timetable].first)
                .to include 'O agendamento de massagens está fechado.'
            end
          end
        end

        context 'when a day of the week does have scheduling' do
          context 'but it is not open yet' do
            let(:timetable) { '2015-08-04' }

            before { Timecop.travel('2015-08-04 14:29') }
            after { Timecop.return }

            it { is_expected.to be_invalid }

            context 'after validation' do
              before { massage.valid? }

              it 'adds an error message to timetable field' do
                expect(massage.errors.messages[:timetable].first)
                  .to include 'O agendamento de massagens está fechado.'
              end
            end
          end

          [nil, '9:01'].each do |timetable|
            context 'and it is open but timetable is out of range or is blank' do
              let(:timetable) { timetable }

              before { Timecop.travel('2015-08-04 15:30') }
              after { Timecop.return }

              it { is_expected.to be_invalid }

              context 'after validation' do
                before { massage.valid? }

                it 'adds an error message to timetable field' do
                  expect(massage.errors.messages[:timetable].first)
                    .to include 'O horário para o agendamento é obrigatório'
                end
              end
            end
          end
        end
      end

      context 'when user tries to schedule more than once a week' do
        let(:timetable) { Time.zone.parse('2015-10-02 9:00') }
        let(:timetable2) { Time.zone.parse('2015-09-30 9:00') }

        before do
          Timecop.travel(Time.zone.parse('2015-09-29 15:00')) do
            create(
              :massage, user: user, masseur: masseur, timetable: timetable2
            )
          end

          Timecop.travel(Time.zone.parse('2015-10-01 15:00'))
        end

        after { Timecop.return }

        it { is_expected.to be_invalid }

        context 'after validation' do
          before { massage.valid? }
          let(:result) do
            'Você já realizou o agendamento semanal permitido. ' \
            'Por favor, tente novamente na semana que vem.'
          end

          it 'adds an error message to timetable field' do
            expect(massage.errors.messages[:timetable].first)
              .to eq result
          end
        end
      end
    end
  end

  describe '.scopes' do
    before do
      allow_any_instance_of(Massage).to receive(:valid?).and_return(true)
    end

    describe '.scheduled_massages' do
      let!(:scheduled_massage) { create(:massage) }
      let!(:attended_massage) { create(:massage, :attended) }
      let!(:cancelled_massage) { create(:massage, :cancelled) }
      let!(:missed_massage) { create(:massage, :missed) }

      let(:result) { [scheduled_massage] }

      subject(:scheduled_massages) { Massage.scheduled_massages }

      it { is_expected.to match_array(result) }
    end

    describe '.past_massages' do
      let!(:scheduled_massage) { create(:massage) }
      let!(:attended_massage) { create(:massage, :attended) }
      let!(:cancelled_massage) { create(:massage, :cancelled) }
      let!(:missed_massage) { create(:massage, :missed) }

      let(:result) { [attended_massage, cancelled_massage, missed_massage] }

      subject(:past_massages) { Massage.past_massages }

      it { is_expected.to match_array(result) }
    end
  end

  describe '#new' do
    subject(:status) { described_class.new.status }

    it { is_expected.to eq 'scheduled' }
  end

  describe '#create' do
    let(:massage) { create(:massage) }
    subject(:status) { massage.status }

    before do
      allow_any_instance_of(Massage).to receive(:valid?).and_return(true)
    end

    it { is_expected.to eq 'scheduled' }
  end

  describe '#can_be_cancelled?' do
    subject(:can_be_cancelled?) { Massage.last.can_be_cancelled? }

    before do
      Timecop.travel('2015-08-18 15:00') do
        create(:massage, timetable: Time.zone.parse('2015-08-19 9:00'))
      end
    end

    context 'when massage can still be cancelled' do
      before { Timecop.freeze('2015-08-19 8:29') }

      after { Timecop.return }

      it { is_expected.to be true }
    end

    context 'when massage cannot be cancelled anymore' do
      before { Timecop.freeze('2015-08-19 8:31') }

      after { Timecop.return }

      it { is_expected.to be false }
    end
  end

  describe '#cancel!' do
    subject(:cancel!) { Massage.last.cancel! }

    before do
      Timecop.travel('2015-08-18 15:00') do
        create(:massage, timetable: Time.zone.parse('2015-08-19 9:00'))
      end
    end

    context 'when massage can still be cancelled' do
      before { Timecop.freeze('2015-08-19 8:29') }

      after { Timecop.return }

      it { is_expected.to_not be_nil }
      it { is_expected.to be_a(Massage) }
    end

    context 'when massage cannot be cancelled anymore' do
      before { Timecop.freeze('2015-08-19 8:31') }

      after { Timecop.return }

      it { is_expected.to be_nil }
    end
  end
end
