class Api::NewsController < ApplicationController
  
  def getInfoNew
    
    respond_to do |format|
      if New.exists?(params[:id])
        @new = New.find(params[:id])
        format.json { render json: @new, status: :ok}
      else
        format.json { render json:{status:"error", code:404, message: "New with ID '" + params[:id] + "' not found"}, status: :not_found}
      end
    end

  end
  
end