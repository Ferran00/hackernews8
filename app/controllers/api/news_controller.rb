class Api::NewsController < ApplicationController
  
  CommentComplete = Struct.new(:comment, :replies, :author_username) do
  end
  
  NewComplete = Struct.new(:new, :comments, :author_username) do
  end
  
  #new and username
  NewNUN = Struct.new(:new, :author_username) do
  end
  
  def funcio(singleComment)
    repliesCompleted = Set[]
    @commentsAlreadyUsed.add(singleComment)
    @comReplies = Comment.where(comment_id: singleComment.id).order('points DESC').all
    @comReplies.each do |rep, i|
      setRep = Set[]
      setRep.add(rep)
      if !@commentsAlreadyUsed.subset?(setRep)
        repliesCompleted.add(funcio(rep))
      end
    end
    #nou per al client frontend
    comment_author_username = User.find(singleComment.user_id).username
    
    return CommentComplete.new(singleComment, repliesCompleted, comment_author_username)
  end
  
  def getInfoNew
    respond_to do |format|
      if request.headers['token'].present?  #si hi ha token
        @key = request.headers['token'].to_s
        if User.exists?(api_key: @key)  #token valid
          @commentsAlreadyUsed = Set[]
          if New.exists?(params[:id])
            @new = New.find(params[:id])
            @resultpartial = Set[]
            @newComments = Comment.where(:new_id => @new.id).order('points DESC').all
            @newComments.each do |com, i|
              if com.comment_id.nil?
                @resultpartial.add(funcio(com))
              end
            end
            #nou per al client frontend
            author_username = User.find(@new.user_id).username
            
            @result = NewComplete.new(@new, @resultpartial, author_username)
            format.json { render json: @result, status: :ok}
          else
            format.json { render json:{status:"error", code:404, message: "New with ID '" + params[:id] + "' not found"}, status: :not_found}
          end
        else  #token no valid
          format.json { render json:{status:"error", code:401, message: "Invalid API key"}, status: :unauthorized}
        end
      else  #no han pasado token
        format.json { render json:{status:"error", code:401, message: "The authentication token is not provided"}, status: :unauthorized}
      end
    end
  end
  
  def getNews 
    respond_to do |format|
      if request.headers['token'].present?  #si hi ha token
        @key = request.headers['token'].to_s
        if User.exists?(api_key: @key)  #token valid
          @new = New.where(:isurl => 1).order('points DESC').all
          
          newNUN = Set[]
          @new.each do |neww, i|
            author_username = User.find(neww.user_id).username
            newNUN.add(NewNUN.new(neww, author_username))
          end
          
          format.json { render json: newNUN, status: :ok}
        else  #token no valid
          format.json { render json:{status:"error", code:401, message: "Invalid API key"}, status: :unauthorized}
        end
      else  #no han pasado token
        format.json { render json:{status:"error", code:401, message: "The authentication token is not provided"}, status: :unauthorized}
      end
    end
  end
  
  def getNewNews
    respond_to do |format|
      if request.headers['token'].present?  #si hi ha token
        @key = request.headers['token'].to_s
        if User.exists?(api_key: @key)  #token valid
          @new = New.order('created_at DESC').all
          
          newNUN = Set[]
          @new.each do |neww, i|
            author_username = User.find(neww.user_id).username
            newNUN.add(NewNUN.new(neww, author_username))
          end
          
          format.json { render json: newNUN, status: :ok}
        else  #token no valid
          format.json { render json:{status:"error", code:401, message: "Invalid API key"}, status: :unauthorized}
        end
      else  #no han pasado token
        format.json { render json:{status:"error", code:401, message: "The authentication token is not provided"}, status: :unauthorized}
      end
    end
  end
  
  def getAskNews
    respond_to do |format|
      if request.headers['token'].present?  #si hi ha token
        @key = request.headers['token'].to_s
        if User.exists?(api_key: @key)  #token valid
          @ask = New.where(:isurl => 0).order('points DESC').all
          
          askNUN = Set[]
          @ask.each do |askk, i|
            author_username = User.find(askk.user_id).username
            askNUN.add(NewNUN.new(askk, author_username))
          end
          
          format.json { render json: askNUN, status: :ok}
        else  #token no valid
          format.json { render json:{status:"error", code:401, message: "Invalid API key"}, status: :unauthorized}
        end
      else  #no han pasado token
        format.json { render json:{status:"error", code:401, message: "The authentication token is not provided"}, status: :unauthorized}
      end
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
            if params[:url].blank? || @existingNewsWithSameURL.blank?  #si no hi ha cap altre "new" amb aquest URL ?? no s'ha introduit url
            
              if (!params[:url].blank?) then isurl=1;
              else isurl=0
              end
              
              if !params[:url].blank? && !params[:text].blank? #si t?? url AND text
                @new = New.new(title: params[:title], url: params[:url], text: "", isurl: isurl, points: 0, user_id: @user.id)
                @new.save
                
                #i ara posem el text com a primer comentari.
                @firstComment = Comment.new(text: params[:text], points: 0,user_id: @user.id, comment_id: nil, new_id: @new.id)  
                @firstComment.save
                format.json { render json:{ new: @new , comment: @firstComment}, status: 201} 
              else
                @new = New.new(title: params[:title], url: params[:url], text: params[:text], isurl: isurl, points: 0, user_id: @user.id)
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
        else format.json { render json:{status:"error", code:401, message: "Invalid API key"}, status: :unauthorized}
        end 
      else format.json { render json:{status:"error", code:401, message: "The authentication token is not provided"}, status: :unauthorized}
      end
    end
  end
  #    
      
  def upvote
    respond_to do |format|
      
      if !params[:newid].nil? #si han passat el param
      
        if request.headers['token'].present?  #si hi ha token
          @key = request.headers['token'].to_s
          if User.exists?(api_key: @key)  #token valid. identifica al user.
            @user  = User.find_by(api_key: @key)
            if New.find(params[:newid]).user_id != @user.id
              if (!Likenew.exists?(user_id: @user.id, new_id: params[:newid]))  #si no est?? liked
                @like = Likenew.new(user_id: @user.id, new_id: params[:newid])
                @like.save
                
                @publi = New.find(params[:newid])
                if !@publi.points.nil?
                  @publi.points +=1
                else
                  @publi.points = 1
                end
                @publi.save
                
                @author = User.find(@publi.user_id)
                @author.karma +=1
                @author.save
                format.json { render json:{status:"OK", code:200, message: "New with ID '" + params[:newid].to_s + "' upvoted successfully"}, status: :ok}  #el status: :ok nidea de si funcionar??
              else   #si ja esta liked
                format.json { render json:{status:"error", code:409, message: "New with ID '" + params[:newid].to_s + "' has already been upvoted by user"}, status: :conflict} #el status: :conflict nidea de si funcionar??
              end
            else
              format.json { render json:{status:"error", code:409, message: "You cannot upvote your own new"}, status: :conflict}
            end
          else  #token no valid
            format.json { render json:{status:"error", code:401, message: "Invalid API key"}, status: :unauthorized}
          end
        else  #no han pasado token
          format.json { render json:{status:"error", code:401, message: "The authentication token is not provided"}, status: :unauthorized}
        end
        
      else #no han passat el param newid
        format.json { render json:{status:"error", code:400, message: "No newid specified (query)"}, status: :bad_request}
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
            
            if (Likenew.exists?(user_id: @user.id, new_id: params[:newid]))  #si est?? liked
              Likenew.find_by(user_id: @user.id, new_id: params[:newid]).destroy
              
              @publi = New.find(params[:newid])
              if !@publi.points.nil?
                @publi.points -=1
              else
                @publi.points = 0
              end
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
          format.json { render json:{status:"error", code:401, message: "The authentication token is not provided"}, status: :unauthorized}
        end
        
      else #no han passat el param newid
        format.json { render json:{status:"error", code:400, message: "No newid specified (query)"}, status: :bad_request}
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
            author_username1 = User.find(new.user_id).username
            @likedSubmissions.add(NewNUN.new(new, author_username1))
          end
          
          format.json { render json: @likedSubmissions, status: :ok}
        else  #token no valid
            format.json { render json:{status:"error", code:401, message: "Invalid API key"}, status: :unauthorized}
        end
      else  #no han pasado token
          format.json { render json:{status:"error", code:401, message: "The authentication token is not provided"}, status: :unauthorized}
      end
    end
 end
  
end