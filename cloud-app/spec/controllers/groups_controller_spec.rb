require 'rails_helper'

RSpec.describe GroupsController, type: :controller do
  describe 'GET #index' do
    before(:all) { create_list(:group, 5) }
    after(:all) { Group.destroy_all }

    it 'returns a 200 status code' do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it 'returns an array body' do
      get :index
      expect(JSON.parse(response.body)).to be_instance_of(Array)
    end

    it 'returns group attributes' do
      get :index
      groups = JSON.parse(response.body)
      expect(groups[0].keys).to contain_exactly('id', 'name')
    end

    it 'filter by name' do
      get :index, params: { name: 'group_1' }
      expect(JSON.parse(response.body).count).to eq(1)
    end
  end

  describe 'GET #show' do
    before(:each) { create(:group, id: 1) }
    after(:each) { Group.destroy_all }

    it 'returns 200 status code' do
      get :show, params: { id: 1 }
      expect(response).to have_http_status(:ok)
    end

    it 'returns correct group attributes' do
      get :show, params: { id: 1 }
      group_data = JSON.parse(response.body)
      expect(group_data).to include('id' => 1, 'name' => Group.first.name)
    end
    
    it 'returns 404 status code' do
      get :show, params: { id: 0 }
      expect(response).to have_http_status(:not_found)
    end

    it 'returns empty response body' do
      get :show, params: { id: 0 }
      expect(response.body).to be_blank
    end
  end

  describe 'POST #create' do
    after { Group.destroy_all }

    it 'creates group' do
      post :create, params: { group: { name: 'foo' } }
      expect(Group.first).to have_attributes(name: 'foo')
    end

    it 'returns group attributes' do
      post :create, params: { group: { name: 'foo' } }
      expect(JSON.parse(response.body).keys).to contain_exactly('id', 'name')
    end
  end

  describe 'DELETE #destroy' do
    let!(:group) { create(:group) }

    it 'deletes group from database' do
      expect {
        delete :destroy, params: { id: group.id }
      }.to change(Group, :count).by(-1)
    end

    it 'returns empty response with 204 status' do
      delete :destroy, params: { id: group.id }
      expect(response).to have_http_status(:no_content)
      expect(response.body).to be_blank
    end
  end
end