class OrdersController < ApplicationController
  include ErrorHandler
  
  before_action :set_order, only: %i[ show edit update destroy ]
  # before_action :require_login, only: :check

  # GET /orders or /orders.json
  def index
    page = params[:page].to_i.positive? ? params[:page].to_i : 1
    per_page = params[:per_page].to_i.positive? ? params[:per_page].to_i : 30

    # @orders = Order.all
    # @orders = Order.includes(:networks, :tags) # Жадная загрузка
    @orders = Order.order(id: :desc)
                   .includes(:networks, :tags)
                   .limit(per_page)
                   .offset(per_page * (page - 1))
    
    render json: { orders: @orders.map { |order|
      order.as_json(only: [:id, :name, :created_at]).merge(
        networks_count: order.networks.count,
        tags: order.tags.as_json(only: [:id, :name])
      )
    } } 
  end
  # GET /orders/1 or /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders or /orders.json
  def create
    @order = Order.new(order_params)

    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: "Order was successfully created." }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1 or /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: "Order was successfully updated." }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy
    @order.destroy!

    respond_to do |format|
      format.html { redirect_to orders_path, status: :see_other, notice: "Order was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def approve
    render json: params
  end

  def calc
    random_number = rand(100)
    render plain: random_number.to_s
  end
  
  def check
    order_service = OrderService.new(session, params)
    result = order_service.check
    render json: result, status: :ok
  end
  
  def first
    @order = Order.first
    if @order
      render :show
    else
      render plain: "No orders found."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.expect(order: [ :name, :status, :cost ])
    end
end
