class SubmitController < ApplicationController
  def index
    
  end


      
  def create
    if !params[:title].blank? && (!params[:url].blank? || !params[:text].blank?)
      
      @existingNewsWithSameURL = New.where(url: params[:url]).first
      if params[:url].blank? || @existingNewsWithSameURL.blank?  #si no hi ha cap altre "new" amb aquest URL ó no s'ha introduit url
      
        if (!params[:url].blank?) then isurl=1;
        else isurl=0
        end
        
        if !params[:url].blank? && !params[:text].blank? #si té url AND text
          @new = New.new(title: params[:title], url: params[:url], text: "", isurl: isurl, points: params[:points])
          #i ara falta posar el text com a primer comentari.
        else
          @new = New.new(title: params[:title], url: params[:url], text: params[:text], isurl: isurl, points: params[:points])
        end
        
        @new.save
        
        redirect_to newest_path
        
      else  #si ja existeix una publicacio amb aquest url
        #redirigir a la pagina d'aquest item
        redirect_to controller: 'news', action: 'item', id: @existingNewsWithSameURL.id
      end
    else
      redirect_to :submit
    end
  end
end