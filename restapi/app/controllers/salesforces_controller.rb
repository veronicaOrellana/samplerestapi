class SalesforcesController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  # GET /users
  def index
    @salesforces = SalesforceData.all
    render json: @salesforces
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    @user = SalesforceData.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def user_params
    params.require(:user).permit(:opportunityID, :transactionID,:goUserID,:datetimeStamp,:IdLink,:json,:created_at,:updated_at)
  end

end