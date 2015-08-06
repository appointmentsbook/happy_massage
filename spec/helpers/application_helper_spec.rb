describe ApplicationHelper do
  describe '#flash_message' do
    subject(:flash_message) { helper.flash_message }

    context 'when key corresponds to flash_in' do
      before { flash[:flash_in] = 'aaaaaaaaaa' }

      it { is_expected.to_not include('aaaaaaaaaa') }
    end

    {
      'alert' => 'ls-alert-danger',
      'notice' => 'ls-alert-success',
      'info' => 'ls-alert-info'
    }.each do |alert, css_class|
      context "when #{alert} can be dismissed" do
        let(:result) do
          "<div class=\"ls-dismissable #{css_class}\">" \
            "<span class=\"ls-dismiss\" data-ls-module=\"dismiss\" " \
            "aria-hidden=\"true\">x</span> teste" \
          '</div>'.html_safe
        end

        before { flash[alert] = 'teste' }

        it { is_expected.to eq(result) }
      end
    end

    {
      'warning' => 'ls-alert-warning',
      'alert_without_dismiss' => 'ls-alert-danger'
    }.each do |alert, css_class|
      context "when #{alert} cannot be dismissed" do
        let(:result) do
          %(<div class=\"ls-dismissable #{css_class}\"> teste</div>)
        end

        before { flash[alert] = 'teste' }

        it { is_expected.to eq(result) }
      end
    end
  end
end
