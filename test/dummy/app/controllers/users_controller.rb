class UsersController < ApplicationController
  def index
    @users = User.includes(:groups)
    respond_to do |format|
      format.html
      format.csv { render csv: @users, fields: [:id, :name, :age, :"groups.first.name"], without_header: true }
      format.tsv { render tsv: @users, fields: [:id, :name, :age, :"groups.first.name"], without_header: true }
    end
  end

  def sjis
    @users = User.includes(:groups).all
    respond_to do |format|
      format.html
      format.csv { render csv: @users, fields: [:id, :name, :age, :"groups.first.name"], encoding: 'SJIS' }
    end
  end
end
