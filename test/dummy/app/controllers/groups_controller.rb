class GroupsController < ApplicationController
  def create
    user_prefix = /^user_/
    @groups = Group.csv_import(params[:group][:file], find_key: :name) do |group, _params, i|
      user_params = _params.select{|k, v| k =~ user_prefix }.to_a.inject({}){|hash, (k, v)|
        hash[k.gsub(user_prefix, '')] = v
        hash
      }
      user_params
      user = User.where(name: user_params['name']).first_or_initialize
      user.attributes = user_params
      group.users << user
    end

    render text: nil
  end
end
