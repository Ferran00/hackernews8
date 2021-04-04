class NewsController < ApplicationController
  def index
    @new = New.where("isurl == 1").order('points DESC').all
    @paginanewest = false
  end
  
  def item
    @ask = New.find(params[:id])
  end
end