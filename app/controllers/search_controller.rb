class SearchController < ApplicationController
  def index
    @query = params[:q] || ''
    @objects = search(@query, params[:tab])
  end

  def list
    @query = params[:q] || ''
    @objects = search(@query)

    respond_to do |format|
      format.json { render json: @objects }
      format.html { render partial: 'list' }
    end
  end

  private

  def search(query, type = nil)
    @objects = []

    models = {
      'users' => User,
      'posts' => Post,
      'communities' => Community,
      'comments' => Comment
    }

    @tab_name = models[type] ? type : 'posts'
    @tab_name = @tab_name.titleize

    @objects << if models[type]
                  models[type].search(query)
                else
                  models['posts'].search(query)
                end

    @objects.flatten!
    @objects.sort_by!(&:created_at).reverse!

    @objects
  end
end
