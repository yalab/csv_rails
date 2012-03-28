class UsersController < ApplicationController
  def index
    @users = User
    respond_to do |format|
      format.html
      format.csv { render csv: @users, fields: [:id, :name, :age, :"groups.first.name"], without_header: true }
    end
  end

  def sjis
    @users = User.all
    respond_to do |format|
      format.html
      format.csv { render csv: @users, fields: [:id, :name, :age, :"groups.first.name"], encoding: 'SJIS' }
    end
  end
end
