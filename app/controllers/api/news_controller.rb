class Api::NewsController < ApplicationController
  
  def getInfoNew
    
    respond_to do |format|
      if request.headers['token'].present?  #si hi ha token
        @key = request.headers['token'].to_s
        if User.exists?(api_key: @key)  #token valid
          #cosa
          if New.exists?(params[:id])
            @new = New.find(params[:id])
            format.json { render json: @new, status: :ok}
          else
            format.json { render json:{status:"error", code:404, message: "New with ID '" + params[:id] + "' not found"}, status: :not_found}
          end
        else  #token no valid
          format.json { render json:{status:"error", code:401, message: "Invalid API key"}, status: :unauthorized}
        end
      else  #no han pasado token
        format.json { render json:{status:"error", code:401, message: "no API key provided"}, status: :unauthorized}
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
          @user  = User.find_by(api_key: @key)
          if !params[:title].blank? && (!params[:url].blank? || !params[:text].blank?)
            
            @existingNewsWithSameURL = New.where(url: params[:url]).first
            if params[:url].blank? || @existingNewsWithSameURL.blank?  #si no hi ha cap altre "new" amb aquest URL ó no s'ha introduit url
            
              if (!params[:url].blank?) then isurl=1;
              else isurl=0
              end
              
              if !params[:url].blank? && !params[:text].blank? #si té url AND text
                @new = New.new(title: params[:title], url: params[:url], text: "", isurl: isurl, points: 0, user_id: @user.id)
                @new.save
                
                #i ara posem el text com a primer comentari.
                @firstComment = Comment.new(text: params[:text], points: 0,user_id: @user.id, comment_id: nil, new_id: @new.id)  
                @firstComment.save
                format.json { render json:{ new: @new , comment: @firstComment}, status: 201} 
              else
                @new = New.new(title: params[:title], url: params[:url], text: params[:text], isurl: isurl, points: params[:points],user_id: @user.id)
                @new.save
                format.json { render json: @new, status: 201}
              end
            else  #si ja existeix una publicacio amb aquest url
              #redirigir a la pagina d'aquest item
              format.json { render json: {status:"error", code: 409, message: "New with same URL already exists"}}
            end
          else
            format.json { render json:{status:"error", code:400, message: "Title is blank or url and text fields are blank"}, status: :bad_request} 
          end
        else format.json { render json: {error: "error", code: 401, message: "The user with token: " + @key + " doesn't exist"}, status: :not_found}
        end 
      else format.json { render json:{status:"error", code:401, message: "The autentication token is not provided"}, status: :forbidden}
      end
    end
  end
      
      
  def upvote
    respond_to do |format|
      
      if !params[:newid].nil? #si han passat el param
      
        if request.headers['token'].present?  #si hi ha token
          @key = request.headers['token'].to_s
          if User.exists?(api_key: @key)  #token valid. identifica al user.
            @user  = User.find_by(api_key: @key)
            if (!Likenew.exists?(user_id: @user.id, new_id: params[:newid]))  #si no està liked
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
          else  #token no valid
            format.json { render json:{status:"error", code:401, message: "Invalid API key"}, status: :unauthorized}
          end
        else  #no han pasado token
          format.json { render json:{status:"error", code:401, message: "no API key provided"}, status: :unauthorized}
        end
        
      else #no han passat el param newid
        format.json { render json:{status:"error", code:400, message: "no newid specified (query)"}, status: :bad_request}
      end
    end
  end
  
  def unvote
    respond_to do |format|
      
      if !params[:newid].nil? #si han passat el param
      
        if request.headers['token'].present?  #si hi ha token
          @key = request.headers['token'].to_s
          if User.exists?(api_key: @key)  #token valid. identifica al user.
            @user  = User.find_by(api_key: @key)
            
            if (Likenew.exists?(user_id: @user.id, new_id: params[:newid]))  #si està liked
              Likenew.find_by(user_id: @user.id, new_id: params[:newid]).destroy
              @publi = New.find(params[:newid])
              @publi.points -=1
              @publi.save
              @author = User.find(@publi.user_id)
              @author.karma -=1
              @author.save
              format.json { render json:{status:"No content", code:204, message: "New with ID '" + params[:newid] + "' unvoted successfully"}, status: :no_content} #no retorna el status i el message perque "pel que es veu" 204 is not supposed to return a body
            else
              format.json { render json:{status:"error", code:404, message: "User has not upvoted a new with ID '" + params[:newid] + "'"}, status: :not_found}
            end
          else  #token no valid
            format.json { render json:{status:"error", code:401, message: "Invalid API key"}, status: :unauthorized}
          end
        else  #no han pasado token
          format.json { render json:{status:"error", code:401, message: "no API key provided"}, status: :unauthorized}
        end
        
      else #no han passat el param newid
        format.json { render json:{status:"error", code:400, message: "no newid specified (query)"}, status: :bad_request}
      end
    end
    
  end
  
  
 def newsUpvotedByUser
    respond_to do |format|
      
      if request.headers['token'].present?  #si hi ha token
        @key = request.headers['token'].to_s
        if User.exists?(api_key: @key)  #token valid. identifica al user.
          @user = User.find_by(api_key: @key)
          
          @likedSubmissions = Set[]
          @likeneww = Likenew.where(:user_id => @user.id).all
          @likeneww.each_with_index do |n,i|
            new = New.find(n.new_id)
            @likedSubmissions.add(new)
          end
          
          format.json { render json: @likedSubmissions, status: :ok}
        else  #token no valid
            format.json { render json:{status:"error", code:401, message: "Invalid API key"}, status: :unauthorized}
        end
      else  #no han pasado token
          format.json { render json:{status:"error", code:401, message: "no API key provided"}, status: :unauthorized}
      end
    end
 end
  
end