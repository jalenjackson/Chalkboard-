class PinsController < ApplicationController

  before_action :find_pin, only: [:show,:edit,:update,:destroy, :upvote]
  before_action :authenticate_user!, except: [:index,:show]

  def index
    @search = Pin.search do
      fulltext params[:search]
    end
    @pins = @search.results
  end

  def new
    @pin = current_user.pins.build
  end

  def show
    @comments = Comment.where(pin_id: @pin).order('created_at DESC')
  end

  def edit
  end

  def profile
    if User.find_by_username(params[:id])
      @username = params[:id]
      @user = User.find_by_username(params[:id])

    else
      redirect_to root_path
    end
    @user_pin = Pin.all.where('user_id = ?', User.find_by_username(params[:id]).id)
  end

  def update
    if @pin.update(pin_params)
      redirect_to @pin, notice: "Pin was succesfully updated"
    else
      render 'edit'
    end
  end

  def destroy
    @pin.destroy
    redirect_to root_path
  end

  def upvote
    @pin.upvote_by current_user
    redirect_to :back
  end

  def create
    @pin = current_user.pins.build (pin_params)

    if @pin.save
      redirect_to @pin , notice: "Succesfully created new pin"
    else
      render 'new'
    end
  end

  private

    def pin_params
      params.require(:pin).permit(:title, :description, :image)
    end

    def find_pin
      @pin = Pin.find(params[:id])
    end
end
