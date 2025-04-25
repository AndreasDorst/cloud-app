class VmsController < ApplicationController
  # GET /vms
  def index
    @vms = Vm.all
    render json: @vms
  end
end
