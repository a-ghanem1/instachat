require 'securerandom'

class ApplicationsController < ApplicationController
  before_action :find_application, only: [:show, :update, :destroy]
  def show
    render json: @application
  end
  
  def create
    # generate token
    token = SecureRandom.base64(10)
    
    # create new application
    @application = Application.new({ name: params[:name], token: token })
    
    if @application.save
      # return that new application
      render json: @application
    else
      # return error
      render json: { 
        message: 'Unable to create application' 
        error: @application.errors.full_messages
      }, status: 400
    end
  end

  def update
    if @application
      # update the application data
      @application.update({ name: params[:name] })

      # return success message
      render json: { message: 'Application updated successfully'}, status: 200
    else
      # return error
      render error: { message: 'Unable to update the application'}, status: 400
    end
  end

  def destroy
    if @application
      # delete the application if exists
      @application.destroy
      render json: { message:'Application deleted successfully'}, status: 200
    else
      render json: { error: 'Unable to delete the application' }, status:400
    end
  end

  private
  
  def find_application
    @application = Application.select(:name, :token, :chats_count, :created_at, :updated_at)
      .find_by(token: params[:token])

    if @application.nil?
      render error: { 
          message: 'Can not find the application with this specefic token'
        }, 
        status: 404
    end
  end
end
 