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

    if models[type]
      @objects << models[type].search(query)
    else
      models.each do |_key, model|
        @objects << model.search(query)
      end
    end

    @objects.flatten!
    @objects.sort_by!(&:created_at).reverse!

    @objects
  end
end
