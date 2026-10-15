class SessionsController < ApplicationController
  def new
  end

  def create
    senha = ENV["ADMIN_PASSWORD"].to_s

    if senha.present? && ActiveSupport::SecurityUtils.secure_compare(params[:password].to_s, senha)
      session[:admin] = true
      redirect_to root_path, notice: "Você entrou como admin."
    else
      flash.now[:alert] = "Senha incorreta."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:admin)
    redirect_to root_path, notice: "Você saiu do modo admin."
  end
end
