class MessagesController < ApplicationController
  before_action :require_edit_permission, except: :index

  def index
    @messages = Message.order(created_at: :desc)
  end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)

    if @message.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @message = Message.find(params[:id])
  end

  def update
    @message = Message.find(params[:id])

    if @message.update(message_params)
      redirect_to root_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    message = Message.find(params[:id])
    message.destroy
    redirect_to root_path
  end

  private

  def require_edit_permission
    redirect_to root_path, alert: "O mural está fechado para novos recados." unless can_edit?
  end

  def message_params
    params.expect(message: [ :author, :content ])
  end
end
