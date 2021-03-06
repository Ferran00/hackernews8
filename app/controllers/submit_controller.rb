class SubmitController < ApplicationController
  def index
    if current_user.nil?
      redirect_to '/auth/google_oauth2'
    end
    
  end

  def create
    
      if !params[:title].blank? && (!params[:url].blank? || !params[:text].blank?)
        
        @existingNewsWithSameURL = New.where(url: params[:url]).first
        if params[:url].blank? || @existingNewsWithSameURL.blank?  #si no hi ha cap altre "new" amb aquest URL ó no s'ha introduit url
        
          if (!params[:url].blank?) then isurl=1;
          else isurl=0
          end
          
          if !params[:url].blank? && !params[:text].blank? #si té url AND text
            @new = New.new(title: params[:title], url: params[:url], text: "", isurl: isurl, points: params[:points], user_id: current_user.id)
            @new.save
            
            #i ara posem el text com a primer comentari.
            @firstComment = Comment.new(text: params[:text], points: 0,user_id: current_user.id, comment_id: nil, new_id: @new.id)  
            @firstComment.save
          else
            @new = New.new(title: params[:title], url: params[:url], text: params[:text], isurl: isurl, points: params[:points],user_id: current_user.id)
            @new.save
          end
          
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