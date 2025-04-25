require 'rails_helper'
require 'webmock/rspec'

RSpec.describe OrdersController, type: :controller do
  let(:valid_params) do
    {
      os: 'linux',
      cpu: '2',
      ram: '4',
      hdd_type: 'ssd',
      hdd_capacity: '100'
    }
  end
  let(:user) { create(:user, balance: 200.0) }

  before do
    possible_orders_url = ENV.fetch('POSSIBLE_ORDERS_URL')
    vm_calc_url = ENV.fetch('VM_CALC_URL')
    
    allow(Rails.application.config).to receive(:possible_orders_url).and_return(possible_orders_url)
    allow(Rails.application.config).to receive(:vm_calc_url).and_return(vm_calc_url)

    # Stub external services
    stub_request(:get, possible_orders_url)
      .to_return(body: {
        'specs' => [{
          'os' => ['linux'],
          'cpu' => [2],
          'ram' => [4],
          'hdd_type' => ['ssd'],
          'hdd_capacity' => { 'ssd' => { 'from' => 50, 'to' => 500 } }
        }]
      }.to_json)

    stub_request(:get, /#{Regexp.escape(vm_calc_url)}/)
      .to_return(body: { 'cost' => 100.0 }.to_json)
  end

  describe 'POST #check' do
    context 'with authenticated user' do
      before { session[:user_id] = user.id }

      it 'returns success response with valid params' do
        post :check, params: valid_params
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to match(
          'result' => true,
          'total' => 100.0,
          'balance' => 200.0,
          'balance_after_transaction' => 100.0
        )
      end
    end
  end
end