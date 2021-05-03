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
  
  def upvote
    
    respond_to do |format|
      
      #if request.headers['X-API-KEY'].present?  #if hay token
      #  @token = request.headers['X-API-KEY'].to_s
      #  @user  = User.find_by_apiKey(@token)
      
        @user = User.find(846455) #stub
        
        if true #es valido (stub)
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
        else#token invalido
        format.json { render json:{status:"error", code:401, message: "Invalid API key"}, status: :unauthorized}
        end
      #else  #no hay token
      #  format.json { render json:{status:"error", code:401, message: "No API key provided"}, status: :unauthorized}
      #end
    end
  end
  
end