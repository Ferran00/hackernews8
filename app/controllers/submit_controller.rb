class SubmitController < ApplicationController
  def index

  end


      
  def create
    if !params[:title].blank? && (!params[:url].blank? || !params[:text].blank?)
      
      @existingNewsWithSameURL = New.where(url: params[:url]).first
      if @existingNewsWithSameURL.blank?  #si no hi ha cap altre "new" amb aquest URL
      
        if (!params[:url].blank?) then isurl=1;
        else isurl=0
        end
          @new = New.new(title: params[:title], url: params[:url], text: params[:text], isurl: isurl, points: params[:points])
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