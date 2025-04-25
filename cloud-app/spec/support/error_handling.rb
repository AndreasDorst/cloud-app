RSpec.shared_context 'with error handling' do
  before do
    routes.draw { post 'check' => 'orders#check' }
  end
end