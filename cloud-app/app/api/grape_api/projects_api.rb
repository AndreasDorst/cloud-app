class GrapeApi
  class ProjectsApi < Grape::API
    format :json

    namespace :projects do
      params do
        optional :state, type: [String, Array]
      end
      get do
        projects = Project.all.includes(:vms)
        present projects, with: GrapeApi::Entities::Project
      end
      # get do
      #   projects = Project.all
      #   if params[:state].present?
      #     projects = projects.where(state: params[:state])
      #   end
      #   present projects, with: GrapeApi::Entities::Project
      # end

      route_param :id, type: Integer do
        get do
          project = Project.find_by(id: params[:id])
          error!({ message: "Проект не найден" }, 404) unless project
          present project
        end

        delete do
          project = Project.find_by(id: params[:id])
          error!({ message: "Проект не найден" }, 404) unless project
          project.destroy
          status 204
        end
      end

      params do
        requires :name, type: String
        requires :state, type: String
      end
      post do
        project = Project.create!(params.slice(:name, :state))
        present project
      end

      route_param :id, type: Integer do
        params do
          optional :name, type: String
          optional :state, type: String
        end
        put do
          project = Project.find_by(id: params[:id])
          error!({ message: "Проект не найден" }, 404) unless project

          project.update!(params.slice(:name, :state).compact)
          present project
        end
      end
    end
  end
end