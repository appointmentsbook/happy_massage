describe Massage do
  describe 'validations' do
    context 'presence validations' do
      it { should validate_presence_of(:masseur_id) }
      it { should validate_presence_of(:user_id) }
    end

    context 'timetable validations' do
      let(:masseur) { create(:user) }
      let(:user) { create(:user) }
      subject(:massage) do
        described_class.new(
          timetable: timetable,
          user_id: user.id,
          masseur_id: masseur.id
        )
      end

      context 'when a day of the week does not have scheduling' do
        let(:timetable) { '2015-08-03' }

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
                  .to include "O horário para o agendamento é obrigatório "
              end
            end
          end
        end
      end
    end

    describe '#new' do
      let(:status) { described_class.new.status }

      it { expect(status).to eq 'pending' }
    end
  end
end
