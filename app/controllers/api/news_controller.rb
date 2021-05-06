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
  
  def getNews 
    respond_to do |format|
      @new = New.where(:isurl => 1).order('points DESC').all
      format.json { render json: @new, status: :ok}
    end
  end
  
  def getNewNews
    respond_to do |format|
      @new = New.order('created_at DESC').all
      format.json { render json: @new, status: :ok}
    end
  end
  
  def getAskNews
    respond_to do |format|
      @ask = New.where(:isurl => 0).order('points DESC').all
      format.json { render json: @ask, status: :ok}
    end
  end
        
  def create
    respond_to do |format|
      if request.headers['token'].present?
        @key = request.headers['token'].to_s
        if User.exists?(api_key: @key)
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
                format.json { render json: @new, id: @contribution.id} 
              else
                @new = New.new(title: params[:title], url: params[:url], text: params[:text], isurl: isurl, points: params[:points],user_id: current_user.id)
                @new.save
                format.json { render json: @new, id: @contribution.id}
              end
              
              redirect_to newest_path
              
            else  #si ja existeix una publicacio amb aquest url
              #redirigir a la pagina d'aquest item
              format.json { render json: @existingNewsWithSameURLnew, status: :ok}
            end
          else
            format.json { render json:{status:"error", code:406, message: "Title is blank or url and text fields are blank"}, status: :conflict} 
          end
        else format.json { render json: {error: "error", code: 404, message: "The user with token: " + @key + " doesn't exist"}, status: :not_found}
        end 
      else format.json { render json:{status:"error", code:403, message: "The autentication token is not provided"}, status: :forbidden}
      end
    end
  end
      
    
    
  
  def upvote
    
    puts "*****************arribo a metode upvote"
    
    respond_to do |format|
    puts "*****************arribo a respond"
      
      # potser rails ja fa una comprovació automàtica de token. no ens funciona per ara el upvote.
      
      #if request.headers['X-API-KEY'].present?  #if hay token
      #  @token = request.headers['X-API-KEY'].to_s
      #  @user  = User.find_by_apiKey(@token)
      
      @user = User.find(846455) #stub
      
      if 1==1 #es valido (stub)
        puts "*****************entro a if true"
        if (!Likenew.exists?(user_id: @user.id, new_id: params[:newid]))  #si no està liked
        puts "*****************entro a if not liked"
          @like = Likenew.new(user_id: @user.id, new_id: params[:newid])
          @like.save
          @publi = New.find(params[:newid])
          @publi.points +=1
          @publi.save
          @author = User.find(@publi.user_id)
          @author.karma +=1
          @author.save
          format.json { render json:{status:"OK", code:200, message: "New with ID '" + params[:newid] + "' upvoted successfully"}, status: :ok}  #el status: :ok nidea de si funcionarà
        else   #si ja esta liked
          format.json { render json:{status:"error", code:409, message: "New with ID '" + params[:newid] + "' has already been upvoted by user"}, status: :conflict} #el status: :conflict nidea de si funcionarà
        end
      else#token invalido
      format.json { render json:{status:"error", code:401, message: "Invalid API key"}, status: :unauthorized}
      end
      
      #else  #no hay token
      #  format.json { render json:{status:"error", code:401, message: "No API key provided"}, status: :unauthorized}
      #end
    end
  end
  
end