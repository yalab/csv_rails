class UsersController < ApplicationController
  def index
    @users = User
    respond_to do |format|
      format.html
      format.csv { render csv: @users, fields: [:id, :name, :age] }
    end
  end

  def sjis
    @users = User.all
    respond_to do |format|
      format.html
      format.csv { render csv: @users, fields: [:id, :name, :age], :encoding => 'SJIS'}
    end
  end
end
