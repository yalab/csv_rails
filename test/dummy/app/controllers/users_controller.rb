class UsersController < ApplicationController
  def index
    @users = User
    respond_to do |format|
      format.html
      format.csv { render csv: @users, fields: [:id, :name, :age] }
    end
  end
end
