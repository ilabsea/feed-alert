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
      redirect_to keyword_sets_path, notice: 'Keyword Set has been created'
    else
      flash.now[:alert] = "Failed to create project"
      render :new
    end
  end

  def edit
    @keyword_set = current_user.keyword_sets.find(params[:id])
  end

  def update
    @keyword_set = current_user.keyword_sets.find(params[:id])

    if @keyword_set.update_attributes(keyword_set_params)
      redirect_to keyword_sets_path, notice: 'Keyword Set has been updated'
    else
      flash.now[:alert] = "Failed to update Keyword Set"
      render :edit
    end
  end

  def destroy
    @keyword_set = current_user.keyword_sets.find(params[:id])

    if @keyword_set.destroy
      redirect_to keyword_sets_path, notice: 'Keyword Set has been deleted'
    else
      redirect_to keyword_sets_path, notice: 'Could not delete Keyword Set'
    end
  end

  private
    def keyword_set_params
      params.require(:keyword_set).permit(:id, :name, :keyword)
    end
end
