class NewController < ApplicationController
  def index
    @new = New.order('created_at DESC').all
    @paginanewest = true
  end
end