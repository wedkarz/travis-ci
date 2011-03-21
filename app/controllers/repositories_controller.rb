class RepositoriesController < ApplicationController
  respond_to :json

  def index
    render :json => repositories.as_json
  end

  def show
    respond_to do |format|
      format.json do
        render :json => repository.as_json
      end
      format.png do
        status = Repository.human_status_by_name("#{params[:user]}/#{params[:name]}")
        send_file(Rails.public_path + "/images/status/#{status}.png", :type => 'image/png', :disposition => 'inline')
      end
    end
  end

  protected
    def repositories
      params[:owner_name] ? Repository.where(:owner_name => params[:owner_name]).timeline : Repository.timeline.recent
    end

    def repository
      @repository ||= params[:id] ? Repository.find(params[:id]) : nil
    end
    helper_method :repository
end
