class GroupsController < ApplicationController
  def index
    groups = Group.all
    groups = groups.where(name: params[:name]) if params[:name].present?
    render json: groups.select(:id, :name)
  end

  def show
    group = Group.select(:id, :name).find_by(id: params[:id])
    return head :not_found unless group
    render json: group
  end
  
  def create
    group = Group.create(group_params)
    render json: group.slice(:id, :name), status: :created
  end

  def destroy
    group = Group.find_by(id: params[:id])
    return head :not_found unless group
    
    group.destroy
    head :no_content
  end
  
  private
  
  def group_params
    params.require(:group).permit(:name)
  end
end