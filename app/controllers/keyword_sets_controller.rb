class KeywordSetsController < ApplicationController
  def index
    @keyword_sets = current_user.keyword_sets.page(params[:page])
  end

  def new
    @keyword_set = KeywordSet.new
  end

  def create
    @keyword_set = current_user.keyword_sets.new(keyword_set_params)
    if @keyword_set.save
      redirect_to keyword_sets_path
    else
      render :new
    end
  end

  private
    def keyword_set_params
      params.require(:keyword_set).permit(:id, :name, :keyword)
    end
end
