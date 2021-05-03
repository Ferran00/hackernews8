class Api::NewsController < ApplicationController
  
    puts "*******************************Arribo a la classe NewsController"
  
  def getInfoNew
    
    puts "*******************************Arribo a NewsController#getInfoNew"
    
    respond_to do |format|
    puts "*******************************Arribo al respond"
      if New.exists?(params[:id])
        @new = New.find(params[:id])
        format.json { render json: @new, status: :ok}
      else
        format.json { render json:{status:"error", code:404, message: "New with ID '" + params[:id] + "' not found"}, status: :not_found}
      end
    end

  end
  
end